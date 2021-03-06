defmodule StatementsConverter.Converters.MilleniumBCP do

  require Logger
  alias StatementsConverter.Statement
  alias StatementsConverter.Statement.Transaction

  import StatementsConverter.Converters.Common, only: [get_payee_from_memo: 1, parse_pt_date: 1]

  def parse(file) do
    Logger.debug fn -> "Processing file #{file}" end
    data = fetch_data(file)
    {:ok, string_io} = StringIO.open(data)
    try do
      string_io
      |> IO.stream(:line)
      |> clear_extras
      |> parse_data
    after
      Logger.debug "closing the string io"
      StringIO.close(string_io)
    end
  end

  defp clear_extras(stream) do
    stream
    |> Stream.drop_while(&(&1 != ";\n" && &1 != "\n"))
    |> Stream.drop(1)
  end

  defp parse_data(stream) do
    Logger.debug fn -> "Parsing data from stream #{inspect stream}" end
    transactions = (stream
    |> Stream.reject(&(length(String.split(&1, ";", parts: 2)) == 1))
    |> CSV.decode!(separator: ?;, strip_fields: true, headers: true)
    |> Enum.map(&parse_row/1))

    %Statement{type: "Bank", transactions: transactions}
  end

  defp parse_row(%{
      "Data lançamento" => launch_date,
      "Data valor" => value_date,
      "Descrição" => memo,
      "Montante" => value }) do
    date = ([parse_pt_date(launch_date),parse_pt_date(value_date)]
    |> Enum.filter(&(&1))
    |> Enum.map(&(&1))
    |> Enum.min_by(&Timex.to_unix/1)
    |> Timex.to_date)
    memo = parse_memo(memo)
    amount = parse_amount(value)
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
    {:ok, data} = File.open(file, [:read], fn(fileio) ->
      IO.binread(fileio, :all)
    end)
    cond do
      String.valid?(data) -> data
      true -> Logger.debug fn -> "File data is not a valid string. Changing encoding!" end
        convert_encoding(data)
    end
  end

  defp convert_encoding(data) do
    :unicode.characters_to_binary(data, {:utf16, :little}, :utf8)
  end

  defp parse_memo(memo) do
    memo
    |> String.replace(~r/\s+/, " ")
    |> String.trim
  end

  defp parse_amount(amount) do
    amount
    |> String.trim
    |> String.to_float
  end
end
