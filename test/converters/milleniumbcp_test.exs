defmodule MilleniumBCPTest do
  use ExUnit.Case
  doctest StatementsConverter.Converters.MilleniumBCP

  alias StatementsConverter.Statement
  alias StatementsConverter.Statement.Transaction

  import StatementsConverter.Converters.MilleniumBCP, only: [parse: 1]

  test "correctly parses a bank extract file" do
    result = parse("test/fixtures/milleniumbcp.csv")

    expected_result = %Statement{
      type: "Bank",
      transactions: [
        %Transaction{amount: -4.55, date: ~D[2016-08-26],
          memo: "MMD0000000 THAT SUPERMARKET",
          payee: "THAT SUPERMARKET"},
        %Transaction{amount: -29.95, date: ~D[2016-08-26],
          memo: "MMD0000000 PLACE TO EAT",
          payee: "PLACE TO EAT"},
        %Transaction{amount: -40.0, date: ~D[2016-08-26],
          memo: "MMD0000000 ATM CGD Lisboa MOV 92",
          payee: "ATM CGD Lisboa MOV 92"},
        %Transaction{amount: -13.2, date: ~D[2016-08-25],
          memo: "DDPT12345678 EASYPAY 12345678901",
          payee: "EASYPAY 12345678901"},
        %Transaction{amount: 500.0, date: ~D[2016-08-25],
          memo: "TRANSFER - STUFF",
          payee: "TRANSFER - STUFF"},
        %Transaction{amount: -13.67, date: ~D[2016-08-23],
          memo: "MMD0000000 REST NICE",
          payee: "REST NICE"},
        %Transaction{amount: 13.45, date: ~D[2016-08-22],
          memo: "TRF. P/O COM LDA DESP",
          payee: "COM LDA DESP"},
        %Transaction{amount: 91.98, date: ~D[2016-08-09],
          memo: "MEDICAL-PAG SERVICOS 1234567890123456",
          payee: "MEDICAL-PAG SERVICOS 1234567890123456"},
        %Transaction{amount: -44.15, date: ~D[2016-08-09],
          memo: "DD PT37100921 EPAL SA 00100449310",
          payee: "EPAL SA 00100449310"},
        %Transaction{amount: -50.0, date: ~D[2016-08-06],
          memo: "TRF MB WAY P/ *****0000",
          payee: "*****0000"},
        %Transaction{amount: -0.02, date: ~D[2016-08-03],
          memo: "MMD IMPOSTO DO SELO",
          payee: "IMPOSTO DO SELO"},
        %Transaction{amount: -0.54, date: ~D[2016-08-03],
          memo: "MMD CUSTO DE SERVICO INTERNACIONAL",
          payee: "CUSTO DE SERVICO INTERNACIONAL"},
        %Transaction{amount: -17.89, date: ~D[2016-08-03],
          memo: "MMD0000 NETPAYSTUFF 19.68USD TC 0.9090447",
          payee: "NETPAYSTUFF 19.68USD TC 0.9090447"},
        %Transaction{amount: -0.99, date: ~D[2016-08-01],
          memo: "MMD0000 NET MMD ITUN 0.99EUR",
          payee: "ITUN 0.99EUR"},
        %Transaction{amount: 50.0, date: ~D[2016-08-01],
          memo: "TRF MB WAY DE SOMEONE",
          payee: "SOMEONE"}
      ]
    }
    assert result == expected_result
  end

end
