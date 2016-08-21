defmodule QIFTest do
  use ExUnit.Case
  doctest StatementsConverter.QIF

  alias StatementsConverter.Statement
  alias StatementsConverter.Statement.Transaction

  import StatementsConverter.QIF, only: [write: 2, write: 3]

  test "writes Bank as default type" do
    {:ok, io} = StringIO.open("")
    transactions = [%Transaction{amount: nil, date: nil,
      memo: nil,
      payee: nil}
    ]
    write(%Statement{type: nil, transactions: transactions}, io)
    result = StringIO.flush(io)
    StringIO.close(io)
    assert result == """
    !Type:Bank
    ^
    """
  end

  test "uses type option as type" do
    {:ok, io} = StringIO.open("")
    transactions = [%Transaction{amount: nil, date: nil,
      memo: nil,
      payee: nil}
    ]
    write(%Statement{type: "CCard", transactions: transactions}, io)
    result = StringIO.flush(io)
    StringIO.close(io)
    assert result == """
    !Type:CCard
    ^
    """
  end

  test "formats dates as \"{0D}-{0M}-{YYYY}\" by default" do
    {:ok, io} = StringIO.open("")
    transactions = [%Transaction{amount: nil, date: ~D[2016-08-06],
      memo: nil,
      payee: nil}
    ]
    write(%Statement{transactions: transactions}, io)
    result = StringIO.flush(io)
    StringIO.close(io)
    assert result == """
    !Type:Bank
    D06-08-2016
    ^
    """
  end

  test "formats dates with passed date format" do
    {:ok, io} = StringIO.open("")
    transactions = [%Transaction{amount: nil, date: ~D[2016-08-06],
      memo: nil,
      payee: nil}
    ]
    write(
      %Statement{transactions: transactions}, 
      io, 
      [date_format: "{0M}-{0D}-{YYYY}"]
    )
    result = StringIO.flush(io)
    StringIO.close(io)
    assert result == """
    !Type:Bank
    D08-06-2016
    ^
    """
  end

  test "amount is correctly written" do
    {:ok, io} = StringIO.open("")
    transactions = [%Transaction{amount: -3.33, date: nil,
      memo: nil,
      payee: nil}
    ]
    write(%Statement{transactions: transactions}, io)
    result = StringIO.flush(io)
    StringIO.close(io)
    assert result == """
    !Type:Bank
    T-3.33
    ^
    """
  end

  test "amounts are rounded to 2 decimal places" do
    {:ok, io} = StringIO.open("")
    transactions = [%Transaction{amount: -3.333, date: nil,
      memo: nil,
      payee: nil}
    ]
    write(%Statement{transactions: transactions}, io)
    result = StringIO.flush(io)
    StringIO.close(io)
    assert result == """
    !Type:Bank
    T-3.33
    ^
    """
  end

  test "amounts can be integers" do
    {:ok, io} = StringIO.open("")
    transactions = [%Transaction{amount: 2, date: nil,
      memo: nil,
      payee: nil}
    ]
    write(%Statement{transactions: transactions}, io)
    result = StringIO.flush(io)
    StringIO.close(io)
    assert result == """
    !Type:Bank
    T2.00
    ^
    """
  end

  test "memo is written correctly" do
    {:ok, io} = StringIO.open("")
    transactions = [%Transaction{amount: nil, date: nil,
      memo: "Hello memo",
      payee: nil}
    ]
    write(%Statement{transactions: transactions}, io)
    result = StringIO.flush(io)
    StringIO.close(io)
    assert result == """
    !Type:Bank
    MHello memo
    ^
    """
  end

  test "payee is written correctly" do
    {:ok, io} = StringIO.open("")
    transactions = [%Transaction{amount: nil, date: nil,
      memo: nil,
      payee: "Hello payee"}
    ]
    write(%Statement{transactions: transactions}, io)
    result = StringIO.flush(io)
    StringIO.close(io)
    assert result == """
    !Type:Bank
    PHello payee
    ^
    """
  end
end