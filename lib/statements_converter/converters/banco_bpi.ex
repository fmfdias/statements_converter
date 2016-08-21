defmodule StatementsConverter.Converters.BancoBPI do

  alias StatementsConverter.Transaction
  import StatementsConverter.Converters.Common, only: [get_payee_from_memo: 1]

  def parse(file) do
    fetch_data(file)
    |> parse_data
  end

  defp parse_data(data) do
    file_type = find_file_type(data)
    parse_data(data, file_type)
  end

  defp parse_data(data, :card) do
    [_,_|rows] = (data
    |> Floki.find("body > table table")
    |> Enum.at(1)
    |> Floki.find("tr"))
    
    Enum.map(rows, &parse_row(&1, :card))
  end

  defp parse_data(data, :bank) do
    [_|rows] = (data
    |> Floki.find("body > table table")
    |> Enum.at(1)
    |> Floki.find("tr"))

    Enum.map(rows, &parse_row(&1, :bank))
  end

  defp parse_row(row, :card) do
    [tr_date_cell,mov_date_cell,memo_cell,_,amount_cell|_] = Floki.find(row, "td")
    
    date = ([parse_date(tr_date_cell),parse_date(mov_date_cell)]
    |> Enum.min_by(&Timex.to_unix/1)
    |> Timex.to_date)
    memo = parse_memo(memo_cell)
    amount = parse_amount(amount_cell)
    payee = get_payee_from_memo(memo)

    %Transaction{
      date: date,
      memo: memo,
      amount: amount * -1,
      payee: payee
    }
  end

  defp parse_row(row, :bank) do
    [tr_date_cell,_,memo_cell,amount_cell|_] = Floki.find(row, "td")
    
    date = parse_date(tr_date_cell) |> Timex.to_date
    memo = parse_memo(memo_cell)
    amount = parse_amount(amount_cell)
    payee = get_payee_from_memo(memo)

    %Transaction{
      date: date,
      memo: memo,
      amount: amount,
      payee: payee
    }
  end

  defp fetch_data(file) do
    data = File.read!(file)
    cond do
      String.valid?(data) -> data
      true -> :iconv.convert("cp1252", "utf-8", data)
    end
  end

  defp find_file_type(data) do
    type_id = (data
    |> Floki.find("body > table table")
    |> Enum.at(0)
    |> Floki.find("tr")
    |> Enum.at(1)
    |> Floki.find("td")
    |> Enum.at(0)
    |> Floki.text)
    
    if type_id == "Cartão", do: :card, else: :bank
  end

  defp parse_date(date_cell) do
    date_cell
    |> Floki.text
    |> String.trim
    |> Timex.parse!("{0D}-{0M}-{YYYY}")
  end

  defp parse_memo(memo_cell) do
    memo_cell
    |> Floki.text
    |> String.trim
  end

  defp parse_amount(amount_cell) do
    amount_cell
    |> Floki.text
    |> String.trim
    |> String.to_float
  end
end