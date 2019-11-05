defmodule StatementsConverter.Converters.BancoBPI.XLSX do

  require Logger
  alias StatementsConverter.Statement
  alias StatementsConverter.Statement.Transaction

  import StatementsConverter.Converters.Common, only: [get_payee_from_memo: 1, parse_pt_date: 1]

  def parse do
    data_list = Xlsxir.get_list
    extract_type = find_file_type(data_list)
    data_list
    |> fetch_data(extract_type)
    |> parse_data(extract_type)
  end

  def find_first_starting_position([],_), do: []
  def find_first_starting_position([[start_position_value | _] | values], start_position_value), do: values
  def find_first_starting_position([_ | values],start_position_value), do: find_first_starting_position(values,start_position_value)

  def clear_data([], values, _), do: Enum.reverse(values)
  def clear_data([[nil|_]|_], values, _), do: Enum.reverse(values)
  def clear_data([tr=[_,_,_,_|_]|rem], values, :bank), do: clear_data(rem,[tr|values], :bank)
  def clear_data([tr=[_,_,_,_,_|_]|rem], values, :card), do: clear_data(rem,[tr|values], :card)
  def clear_data(_, values, _), do: Enum.reverse(values)

  def fetch_data(data, :bank) do
    find_first_starting_position(data, "Data Mov.")
    |> clear_data([], :bank)
  end

  def fetch_data(data, :card) do
    find_first_starting_position(data, "Data Transação")
    |> clear_data([], :card)
  end

  defp find_file_type([]), do: :bank
  defp find_file_type([["Tipo de Cartão" | _] | _]), do: :card
  defp find_file_type([_ | values]), do: find_file_type(values)

  defp parse_data(rows, type) do
    Logger.debug fn -> "Going to processe #{length(rows)} entries" end
    %Statement{type: get_statement_type(type), transactions: Enum.map(rows, &parse_row(&1, type))}
  end

  defp get_statement_type(:bank), do: "Bank"
  defp get_statement_type(:card), do: "CCard"


  defp parse_row([tr_date_cell,mov_date_cell,memo_cell,amount_cell|_], :bank) do
    Logger.debug fn ->
      """
      Transaction info:
        tr_date_cell: #{inspect tr_date_cell}
        mov_date_cell: #{inspect mov_date_cell}
        memo_cell: #{inspect memo_cell}
        amount_cell: #{inspect amount_cell}
      """
    end
    date = ([parse_pt_date(tr_date_cell),parse_pt_date(mov_date_cell)]
    |> Enum.min_by(&Timex.to_unix/1)
    |> Timex.to_date)
    memo = parse_memo(memo_cell)
    payee = get_payee_from_memo(memo)

    Logger.debug fn ->
      """
      Transaction info:
        date: #{date}
        memo: #{memo}
        amount: #{amount_cell}
        payee: #{payee}
      """

    end
    %Transaction{
      date: date,
      memo: memo,
      amount: amount_cell,
      payee: payee
    }
  end

  defp parse_row([tr_date_cell,mov_date_cell,memo_cell,_,amount_cell|_], :card) do
    Logger.debug fn ->
      """
      Transaction info:
        tr_date_cell: #{inspect tr_date_cell}
        mov_date_cell: #{inspect mov_date_cell}
        memo_cell: #{inspect memo_cell}
        amount_cell: #{inspect amount_cell}
      """
    end
    date = ([tr_date_cell,tr_date_cell]
    |> Enum.min_by(&Timex.to_unix/1)
    |> Timex.to_date)
    memo = parse_memo(memo_cell)
    payee = get_payee_from_memo(memo)

    Logger.debug fn ->
      """
      Transaction info:
        date: #{date}
        memo: #{memo}
        amount: #{amount_cell * -1}
        payee: #{payee}
      """

    end
    %Transaction{
      date: date,
      memo: memo,
      amount: amount_cell * -1,
      payee: payee
    }
  end

  defp parse_memo(memo_cell) do
    memo_cell
    |> String.replace(~r/\s+/, " ")
    |> String.trim
  end

end
