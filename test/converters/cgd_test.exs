defmodule CGDTest do
  use ExUnit.Case
  doctest StatementsConverter.Converters.CGD

  alias StatementsConverter.Statement
  alias StatementsConverter.Statement.Transaction

  import StatementsConverter.Converters.CGD, only: [parse: 1]

  test "correctly parses a bank extract file" do
    result = parse("test/fixtures/cgd.tsv")

    expected_result = %Statement{
      type: "Bank",
      transactions: [
        %Transaction{amount: 10.0,
          date: ~D[2017-01-09],
          memo: "TRF P2P 910xxx000",
          payee: "910xxx000"},
        %Transaction{amount: -6.1,
          date: ~D[2017-01-06],
          memo: "BX VALOR 03 TRANSACCO",
          payee: "BX VALOR 03 TRANSACCO"},
        %Transaction{amount: -20.0,
          date: ~D[2017-01-07],
          memo: "LEVANTAMENTO Place atm",
          payee: "LEVANTAMENTO Place atm"},
        %Transaction{amount: -25.0,
          date: ~D[2017-01-06],
          memo: "COMPRA GYM",
          payee: "GYM"},
        %Transaction{amount: -14.9,
          date: ~D[2017-01-06],
          memo: "COMPRA Italian Restaurant",
          payee: "Italian Restaurant"},
        %Transaction{amount: -200.0,
          date: ~D[2017-01-04],
          memo: "Stuff",
          payee: "Stuff"},
        %Transaction{amount: -134.0,
          date: ~D[2017-01-04],
          memo: "LIGHT",
          payee: "LIGHT"},
        %Transaction{amount: -15.0,
          date: ~D[2017-01-03],
          memo: "INSURANCE COMP",
          payee: "INSURANCE COMP"},
        %Transaction{amount: -165.0,
          date: ~D[2017-01-02],
          memo: "TRF CXDOL",
          payee: "CXDOL"},
        %Transaction{amount: -100.0,
          date: ~D[2016-12-02],
          memo: "COBRANCA PRESTACAO",
          payee: "PRESTACAO"},
        %Transaction{amount: -0.58,
          date: ~D[2017-01-01],
          memo: "JURLDN 0000000000000",
          payee: "JURLDN 0000000000000"},
        %Transaction{amount: -60.0,
          date: ~D[2016-12-31],
          memo: "LEVANTAMENTO Ed Manch",
          payee: "LEVANTAMENTO Ed Manch"},
        %Transaction{amount: -160.58,
          date: ~D[2016-12-30],
          memo: "DEBITO ARREDONDAMENTO",
          payee: "DEBITO ARREDONDAMENTO"},
        %Transaction{amount: 160.58,
          date: ~D[2016-12-30],
          memo: "CREDITO ARREDONDAMENT",
          payee: "CREDITO ARREDONDAMENT"},
        %Transaction{amount: 1.0e3,
          date: ~D[2016-12-29],
          memo: "TRF WORK",
          payee: "WORK"},
        %Transaction{amount: 69.95,
          date: ~D[2016-12-17],
          memo: "DEVOLUCAO Store",
          payee: "Store"},
        %Transaction{amount: -69.95,
          date: ~D[2016-12-17],
          memo: "COMPRA Store",
          payee: "Store"},
        %Transaction{amount: -1.39,
          date: ~D[2016-12-16],
          memo: "TRF INT MEDP RENOV PU",
          payee: "MEDP RENOV PU"}]
       }
    assert result == expected_result
  end

end
