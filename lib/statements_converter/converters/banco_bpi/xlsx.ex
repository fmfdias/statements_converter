defmodule StatementsConverter.Converters.BancoBPI.XLSX do

  require Logger
  alias StatementsConverter.Statement
  alias StatementsConverter.Statement.Transaction

  import StatementsConverter.Converters.Common, only: [get_payee_from_memo: 1]

  def parse do
    Xlsxir.get_list
    |> fetch_data
    |> parse_data(:card)
  end

  def find_first_starting_position([]), do: []
  def find_first_starting_position([["Data Transacção" | _] | values]), do: values
  def find_first_starting_position([_ | values]), do: find_first_starting_position(values)

  def clear_data([], values), do: Enum.reverse(values)
  def clear_data([[nil|_]|_], values), do: Enum.reverse(values)
  def clear_data([tr|rem], values), do: clear_data(rem,[tr|values])

  def fetch_data(data) do
    find_first_starting_position(data)
    |> clear_data([])
  end

  defp parse_data(rows, :card) do
    Logger.debug fn -> "Going to processe #{length(rows)} entries" end
    %Statement{type: "CCard", transactions: Enum.map(rows, &parse_row(&1, :card))}
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
    date = ([tr_date_cell,mov_date_cell]
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
