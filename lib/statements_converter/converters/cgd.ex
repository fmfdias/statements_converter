defmodule StatementsConverter.Converters.CGD do

  require Logger
  alias StatementsConverter.Statement
  alias StatementsConverter.Statement.Transaction

  import StatementsConverter.Converters.Common, only: [get_payee_from_memo: 1]

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
    |> Stream.drop_while(&(!Regex.match?(~r/^Data\smov\.\s.*?\n/,&1)))
  end

  defp parse_data(stream) do
    Logger.debug fn -> "Parsing data from stream #{inspect stream}" end

    transactions = (
      stream
      |> Stream.reject(&(length(String.split(&1, "\t", parts: 2)) == 1))
      |> CSV.decode!(separator: ?\t, strip_fields: true, headers: true)
      |> Stream.map(&parse_row/1)
      |> Enum.filter(&(!is_nil(&1)))
    )

    Logger.debug fn -> "transactions #{inspect transactions}" end

    %Statement{type: "Bank", transactions: transactions}
  end

  defp parse_row(%{"Crédito" => "","Débito" => ""}), do: nil

  defp parse_row(test = %{
      "Data mov." => launch_date,
      "Data valor" => value_date,
      "Descrição" => memo,
      "Débito" => debit_value,
      "Crédito" => credit_value,
    }) do

    Logger.debug fn -> inspect test end

    log = &(Logger.debug(fn -> "#{memo} - #{inspect &1}" end) && &1)

    date = ([parse_date(launch_date),parse_date(value_date)]
    |> Enum.filter_map(&(&1), &(&1))
    |> log.()
    |> Enum.min_by(&Timex.to_unix/1)
    |> Timex.to_date)

    memo = parse_memo(memo)
    amount = get_amount(debit_value, credit_value)
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

  defp parse_date(date_text) do
    date_text
    |> parse_text_date
  end

  defp parse_text_date(""), do: nil

  defp parse_text_date(text) do
    Timex.parse!(text, "{0D}-{0M}-{YYYY}")
  end

  defp parse_memo(memo) do
    memo
    |> String.replace(~r/\s+/, " ")
    |> String.trim
  end

  defp get_amount("", credit), do: parse_amount(credit)
  defp get_amount(debit, ""), do: parse_amount(debit) * -1

  defp parse_amount(amount) do
    amount
    |> String.trim
    |> String.replace(".","")
    |> String.to_float
  end
end
