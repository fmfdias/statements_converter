defmodule StatementsConverter.Statement.Transaction do
  defstruct date: %Date{year: 0, month: 0, day: 0}, amount: 0.0, memo: "", payee: ""
end