defmodule BancoCTTTest do
  use ExUnit.Case
  doctest StatementsConverter.Converters.BancoCTT

  alias StatementsConverter.Statement
  alias StatementsConverter.Statement.Transaction

  import StatementsConverter.Converters.BancoCTT, only: [parse: 1]

  test "correctly parses a bank extract file" do
    result = parse("test/fixtures/bancoctt.csv")

    expected_result = %Statement{
      type: "Bank",
      transactions: [
        %Transaction{
          amount: -51.45,
          date: ~D[2018-12-28],
          memo: "A.S. PLACE PORTO PT - Cartao 0000",
          payee: "A.S. PLACE PORTO PT"
        },
        %Transaction{
          amount: -31.11,
          date: ~D[2018-12-27],
          memo: "CENTRO DE INSPECCAO 2685-332 P VELHO PT - Cartao 0000",
          payee: "CENTRO DE INSPECCAO 2685-332 P VELHO PT"
        },
        %Transaction{
          amount: -8.23,
          date: ~D[2018-12-27],
          memo: "FARMACY LDA 1000-000 LISBOA PT - Cartao 0000",
          payee: "FARMACY LDA 1000-000 LISBOA PT"
        },
        %Transaction{
          amount: -9.3,
          date: ~D[2018-12-24],
          memo: "Transferência ATM / Contactless / Portagem - Cartao 0000",
          payee: "Transferência ATM / Contactless / Portagem"
        },
        %Transaction{
          amount: -42.5,
          date: ~D[2018-12-23],
          memo: "THAT SUPERMARKET REGUENGOS MONSARAZPT - Cartao 0000",
          payee: "THAT SUPERMARKET REGUENGOS MONSARAZPT"
        },
        %Transaction{
          amount: -50,
          date: ~D[2018-12-22],
          memo: "A.S. PLACE LISBOA PT - Cartao 0000",
          payee: "A.S. PLACE LISBOA PT"
        },
        %Transaction{
          amount: -4.93,
          date: ~D[2018-12-18],
          memo: "THAT ONLINE SUPERMARKET LISBOA PT - Cartao 0000",
          payee: "THAT ONLINE SUPERMARKET LISBOA PT"
        },
        %Transaction{
          amount: -53.45,
          date: ~D[2018-12-15],
          memo: "THAT SUPERMARKET 1000-000 LISBOA PT - Cartao 0000",
          payee: "THAT SUPERMARKET 1000-000 LISBOA PT"
        },
        %Transaction{
          amount: -50.99,
          date: ~D[2018-12-15],
          memo: "STORE CENTER LISBOA - Cartao 0000",
          payee: "STORE CENTER LISBOA"
        },
        %Transaction{
          amount: -28.5,
          date: ~D[2018-12-15],
          memo: "COFFEE SHOP 1000-000-LISBOA PT - Cartao 0000",
          payee: "COFFEE SHOP 1000-000-LISBOA PT"
        },
        %Transaction{
          amount: 300.76,
          date: ~D[2018-12-10],
          memo: "PERSONAL TRANSFER",
          payee: "PERSONAL TRANSFER"
        },
        %Transaction{
          amount: -100,
          date: ~D[2018-12-07],
          memo: "PAYMENT TRANSFER",
          payee: "PAYMENT TRANSFER"
        },
        %Transaction{
          amount: 200.58,
          date: ~D[2018-12-07],
          memo: "PERSONAL TRANSFER",
          payee: "PERSONAL TRANSFER"
        }
      ]
    }

    assert result == expected_result
  end
end
