defmodule StatementsConverter.QIF do
  alias StatementsConverter.Transaction

  @supported_fields [
    date:           "D",
    amount:         "T",
    payee:          "P",
    memo:           "M",
    end:            "^",
  ]

  @write_defaults [
    date_format: "{0D}/{0M}/{YYYY}",
    type: "bank"
  ]


  def write(transactions, io, opt \\ []) do
    opt = Keyword.merge(@write_defaults,opt)
    write_header(opt[:type],io)
    transactions
    |> Enum.each(&write_transaction(&1, io, opt))
  end

  def write_transaction(transaction = %Transaction{}, io, opt) do
    @supported_fields
    |> Keyword.keys
    |> Enum.each(&write_field(&1, transaction, io, opt))
  end

  def write_field(:date, %Transaction{date: nil}, _io, _opt), do: nil

  def write_field(:date, %Transaction{date: date}, io, opt) do
    IO.puts(io, "D#{Timex.format!(date,opt[:date_format])}")
  end

  def write_field(:amount, %Transaction{amount: nil}, _io, _opt), do: nil

  def write_field(:amount, %Transaction{amount: amount}, io, _opt) when is_float(amount) do
    IO.puts(io, "T#{Float.to_string(amount, decimals: 2)}")
  end

  def write_field(:amount, %Transaction{amount: amount}, io, _opt) when is_integer(amount) do
    f_amount = amount/1.0
    IO.puts(io, "T#{Float.to_string(f_amount, decimals: 2)}")
  end

  def write_field(:payee, %Transaction{payee: nil}, _io, _opt), do: nil

  def write_field(:payee, %Transaction{payee: payee}, io, _opt) do
    IO.puts(io, "P#{payee}")
  end

  def write_field(:memo, %Transaction{memo: nil}, _io, _opt), do: nil

  def write_field(:memo, %Transaction{memo: memo}, io, _opt) do
    IO.puts(io, "M#{memo}")
  end

  def write_field(:end, %Transaction{}, io, _opt) do
    IO.puts(io, "^")
  end

  def write_header(type\\"Bank", io) do
    IO.puts(io, "!Type:#{type}")
  end
end