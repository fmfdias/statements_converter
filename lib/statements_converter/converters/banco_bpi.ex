defmodule StatementsConverter.Converters.BancoBPI do

  require Logger
  alias StatementsConverter.Statement
  alias StatementsConverter.Statement.Transaction

  import StatementsConverter.Converters.Common, only: [get_payee_from_memo: 1]

  def parse(file) do
    Logger.debug fn -> "Processing file #{file}" end
    fetch_data(file)
    |> parse_data
  end

  defp parse_data(data) do
    file_type = find_file_type(data)
    Logger.debug fn -> "The being processed was recognized as #{file_type}" end
    parse_data(data, file_type)
  end

  defp parse_data(data, :card) do
    [_,_|rows] = (data
    |> Floki.find("body > table table")
    |> Enum.at(1)
    |> Floki.find("tr"))
    
    Logger.debug fn -> "Going to processe #{length(rows)} entries" end
    %Statement{type: "CCard", transactions: Enum.map(rows, &parse_row(&1, :card))}
  end

  defp parse_data(data, :bank) do
    [_|rows] = (data
    |> Floki.find("body > table table")
    |> Enum.at(1)
    |> Floki.find("tr"))

    Logger.debug fn -> "Going to processe #{length(rows)} entries" end
    %Statement{type: "Bank", transactions: Enum.map(rows, &parse_row(&1, :bank))}
  end

  defp parse_row(row, :card) do
    [tr_date_cell,mov_date_cell,memo_cell,_,amount_cell|_] = Floki.find(row, "td")
    Logger.debug fn -> 
      """
      Transaction info:
        tr_date_cell: #{inspect tr_date_cell}
        mov_date_cell: #{inspect mov_date_cell}
        memo_cell: #{inspect memo_cell}
        amount_cell: #{inspect amount_cell}
      """
    end
    date = ([parse_date(tr_date_cell),parse_date(mov_date_cell)]
    |> Enum.filter_map(&(&1), &(&1))
    |> Enum.min_by(&Timex.to_unix/1)
    |> Timex.to_date)
    memo = parse_memo(memo_cell)
    amount = parse_amount(amount_cell)
    payee = get_payee_from_memo(memo)

    Logger.debug fn -> 
      """
      Transaction info:
        date: #{date}
        memo: #{memo}
        amount: #{amount * -1}
        payee: #{payee}
      """

    end
    %Transaction{
      date: date,
      memo: memo,
      amount: amount * -1,
      payee: payee
    }
  end

  defp parse_row(row, :bank) do
    [tr_date_cell,mov_date_cell,memo_cell,amount_cell|_] = Floki.find(row, "td")

    date = ([parse_date(tr_date_cell),parse_date(mov_date_cell)]
    |> Enum.filter_map(&(&1), &(&1))
    |> Enum.min_by(&Timex.to_unix/1)
    |> Timex.to_date)
    memo = parse_memo(memo_cell)
    amount = parse_amount(amount_cell)
    payee = get_payee_from_memo(memo)

    Logger.debug fn ->
      """
      Transaction info:
        date: #{date}
        memo: #{memo}
        amount: #{amount}
        payee: #{payee}
      """
    end

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
      true -> Logger.debug "File data is not a valid string. Changing encoding!"
        Codepagex.to_string!(data, "VENDORS/MICSFT/WINDOWS/CP1252")
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
    |> parse_text_date
  end

  defp parse_text_date(""), do: nil

  defp parse_text_date(text) do
    text
    |> String.replace("/","-")
    |> Timex.parse!("{0D}-{0M}-{YYYY}")
  end

  defp parse_memo(memo_cell) do
    memo_cell
    |> Floki.text
    |> String.replace(~r/\s+/, " ")
    |> String.trim
  end

  defp parse_amount(amount_cell) do
    amount_cell
    |> Floki.text
    |> String.trim
    |> String.replace(".","")
    |> String.to_float
  end
end