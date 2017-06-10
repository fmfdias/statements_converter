defmodule BancoBPITest do
  use ExUnit.Case
  doctest StatementsConverter

  alias StatementsConverter.Statement
  alias StatementsConverter.Statement.Transaction

  import StatementsConverter.Converters.BancoBPI, only: [parse: 1]

  test "correctly parses a card extract file with the old format" do
    result = parse("test/fixtures/cartaobpi.xls")

    expected_result = %Statement{
      type: "CCard",
      transactions: [
        %Transaction{amount: -40.0, date: ~D[2016-08-06],
          memo: "A.S. PADRE CRUZ LISBOA",
          payee: "A.S. PADRE CRUZ LISBOA"},
        %Transaction{amount: -32.51, date: ~D[2016-08-04],
          memo: "FSPRG.COM FLEXIBITS COVENTRY",
          payee: "FSPRG.COM FLEXIBITS COVENTRY"},
        %Transaction{amount: -2.99, date: ~D[2016-08-05],
          memo: "ITUNES.COM/BILL ITUNES.COM",
          payee: "ITUNES.COM/BILL ITUNES.COM"},
        %Transaction{amount: -146.88, date: ~D[2016-08-05],
          memo: "AMAZON.ES COMPRA amazon.es/ayu",
          payee: "AMAZON.ES COMPRA amazon.es/ayu"},
        %Transaction{amount: -10.99, date: ~D[2016-08-07],
          memo: "Spotify P000A00AAA Stockholm",
          payee: "Spotify P000A00AAA Stockholm"},
        %Transaction{amount: -22.21, date: ~D[2016-08-14],
          memo: "Amazon UK Retail AMAZ 1,1658792",
          payee: "Amazon UK Retail AMAZ 1,1658792"}
      ]
    }

    assert result == expected_result
  end

  test "correctly parses a card extract file with the new format" do
    result = parse("test/fixtures/cartaobpi_nao_extractados.xlsx")

    expected_result = %Statement{
      type: "CCard",
      transactions: [
        %Transaction{amount: -40.0, date: ~D[2016-08-06],
          memo: "A.S. PADRE CRUZ LISBOA",
          payee: "A.S. PADRE CRUZ LISBOA"},
        %Transaction{amount: -32.51, date: ~D[2016-08-04],
          memo: "FSPRG.COM FLEXIBITS COVENTRY",
          payee: "FSPRG.COM FLEXIBITS COVENTRY"},
        %Transaction{amount: -2.99, date: ~D[2016-08-05],
          memo: "ITUNES.COM/BILL ITUNES.COM",
          payee: "ITUNES.COM/BILL ITUNES.COM"},
        %Transaction{amount: -146.88, date: ~D[2016-08-05],
          memo: "AMAZON.ES COMPRA amazon.es/ayu",
          payee: "AMAZON.ES COMPRA amazon.es/ayu"},
        %Transaction{amount: -10.99, date: ~D[2016-08-07],
          memo: "Spotify P000A00AAA Stockholm",
          payee: "Spotify P000A00AAA Stockholm"},
        %Transaction{amount: -22.21, date: ~D[2016-08-14],
          memo: "Amazon UK Retail AMAZ 1,1658792",
          payee: "Amazon UK Retail AMAZ 1,1658792"}
      ]
    }

    assert result == expected_result
  end

  test "correctly parses a card (full) extract file with the new format" do
    result = parse("test/fixtures/cartaobpi_extractados.xlsx")

    expected_result = %Statement{
      type: "CCard",
      transactions: [
        %Transaction{amount: -40.0, date: ~D[2016-08-06],
          memo: "A.S. PADRE CRUZ LISBOA",
          payee: "A.S. PADRE CRUZ LISBOA"},
        %Transaction{amount: -32.51, date: ~D[2016-08-04],
          memo: "FSPRG.COM FLEXIBITS COVENTRY",
          payee: "FSPRG.COM FLEXIBITS COVENTRY"},
        %Transaction{amount: -2.99, date: ~D[2016-08-05],
          memo: "ITUNES.COM/BILL ITUNES.COM",
          payee: "ITUNES.COM/BILL ITUNES.COM"},
        %Transaction{amount: -146.88, date: ~D[2016-08-05],
          memo: "AMAZON.ES COMPRA amazon.es/ayu",
          payee: "AMAZON.ES COMPRA amazon.es/ayu"},
        %Transaction{amount: -10.99, date: ~D[2016-08-07],
          memo: "Spotify P000A00AAA Stockholm",
          payee: "Spotify P000A00AAA Stockholm"},
        %Transaction{amount: -22.21, date: ~D[2016-08-14],
          memo: "Amazon UK Retail AMAZ 1,1658792",
          payee: "Amazon UK Retail AMAZ 1,1658792"}
      ]
    }

    assert result == expected_result
  end

  test "correctly parses a bank extract file with the old format" do
    result = parse("test/fixtures/bancobpi.xls")

    expected_result = %Statement{
      type: "Bank",
      transactions: [
        %Transaction{amount: -4.55, date: ~D[2016-08-19],
          memo: "19/08 COMPRA ELEC 1234567/10 THAT SUPERMARKET 1700-036 LI",
          payee: "THAT SUPERMARKET 1700-036 LI"},
        %Transaction{amount: -6.55, date: ~D[2016-08-18],
          memo: "18/08 COMPRA ELEC 1234567/09 PLACE TO EAT LISBOA",
          payee: "PLACE TO EAT LISBOA"},
        %Transaction{amount: -7.5, date: ~D[2016-08-17],
          memo: "17/08 COMPRA ELEC 1234567/08 OTHER PLACE LISBOA",
          payee: "OTHER PLACE LISBOA"},
        %Transaction{amount: -3.51, date: ~D[2016-08-17],
          memo: "17/08 COMPRA ELEC 1234567/07 BIO STUFF LISBOA",
          payee: "BIO STUFF LISBOA"},
        %Transaction{amount: -2.13, date: ~D[2016-08-17],
          memo: "17/08 COMPRA ELEC 1234567/07 COFFE SHOP BARREIRO",
          payee: "COFFE SHOP BARREIRO"},
        %Transaction{amount: 7.6, date: ~D[2016-08-17],
          memo: "17/08 COMPRA ELEC 1234567/07 BUY THINGS LISBOA",
          payee: "BUY THINGS LISBOA"},
        %Transaction{amount: -10.0, date: ~D[2016-08-16],
          memo: "TRANSF. MB WAY ELEC 0000000/00 P/TLM *****0000",
          payee: "*****0000"}
      ]
    }

    assert result == expected_result
  end

  test "correctly parses a bank extract file with the new format" do
    result = parse("test/fixtures/bancobpi.xlsx")

    expected_result = %Statement{
      type: "Bank",
      transactions: [
        %Transaction{amount: -4.55, date: ~D[2016-08-19],
          memo: "19/08 COMPRA ELEC 1234567/10 THAT SUPERMARKET 1700-036 LI",
          payee: "THAT SUPERMARKET 1700-036 LI"},
        %Transaction{amount: -6.55, date: ~D[2016-08-18],
          memo: "18/08 COMPRA ELEC 1234567/09 PLACE TO EAT LISBOA",
          payee: "PLACE TO EAT LISBOA"},
        %Transaction{amount: -7.5, date: ~D[2016-08-17],
          memo: "17/08 COMPRA ELEC 1234567/08 OTHER PLACE LISBOA",
          payee: "OTHER PLACE LISBOA"},
        %Transaction{amount: -3.51, date: ~D[2016-08-17],
          memo: "17/08 COMPRA ELEC 1234567/07 BIO STUFF LISBOA",
          payee: "BIO STUFF LISBOA"},
        %Transaction{amount: -2.13, date: ~D[2016-08-17],
          memo: "17/08 COMPRA ELEC 1234567/07 COFFE SHOP BARREIRO",
          payee: "COFFE SHOP BARREIRO"},
        %Transaction{amount: 7.6, date: ~D[2016-08-17],
          memo: "17/08 COMPRA ELEC 1234567/07 BUY THINGS LISBOA",
          payee: "BUY THINGS LISBOA"},
        %Transaction{amount: -10.0, date: ~D[2016-08-16],
          memo: "TRANSF. MB WAY ELEC 0000000/00 P/TLM *****0000",
          payee: "*****0000"}
      ]
    }

    assert result == expected_result
  end

end
