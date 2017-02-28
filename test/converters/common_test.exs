defmodule CommonTest do
  use ExUnit.Case
  doctest StatementsConverter

  import StatementsConverter.Converters.Common, only: [get_payee_from_memo: 1]

  test "extracts correct data from SEPA charges" do
    [{"COBR SEPA 01196588692 COMPANY SA", "COMPANY SA"},
     {"COBRANCA DD SEPA PA15LY0003FPTLRO3241 ANOTHER COMPANY HE ", "ANOTHER COMPANY HE"}]
    |> Enum.each(fn {st,res} -> assert get_payee_from_memo(st) == res end)
  end

  test "extracts correct data from purchases" do
    [{"19/08 COMPRA ELEC 0000000/10 SUPERMARKET 1234-036 LI", "SUPERMARKET 1234-036 LI"},
     {"10/08 COMPRA ELEC 0000000/02 PLACE TO EAT TOWN", "PLACE TO EAT TOWN"},
     {"01/08 COMPRA ELEC 0000000/93 ANOTHER PLACE WITH, LA", "ANOTHER PLACE WITH, LA"}]
    |> Enum.each(fn {st,res} -> assert get_payee_from_memo(st) == res end)
  end

  test "extracts correct data from transfers" do
    [{"06/08 TRF MB WAY 00037616 DE JOHN DO", "JOHN DO"},
     {"TRF 40 P/ PT00000000000000000000000 SHARED ACCOUNT", "SHARED ACCOUNT"},
     {"TRF 0003320 DE YOUR EMPLOYER, LDA", "YOUR EMPLOYER, LDA"}]
    |> Enum.each(fn {st,res} -> assert get_payee_from_memo(st) == res end)
  end

  test "extracts correct data for ATM withdrawals" do
    [{"13/07 LEV. ATM ELEC 0000000/79 Street in, town", "LEV. ATM Street in, town"}]
    |> Enum.each(fn {st,res} -> assert get_payee_from_memo(st) == res end)
  end

  test "it clears extra whitespaces" do
    [{"06/08 TRF MB WAY 00037616 DE JOHN DO", "JOHN DO"},
     {"REFORCO DEPOSITO   A PRAZO 000/000", "REFORCO DEPOSITO A PRAZO 000/000"},
     {"01/08 COMPRA ELEC 0000000/93 ANOTHER    PLACE WITH, LA", "ANOTHER PLACE WITH, LA"},
     {"COBRANCA DD SEPA PA15LY0003FPTLRO3241 ANOTHER COMPANY HE ", "ANOTHER COMPANY HE"}]
    |> Enum.each(fn {st,res} -> assert get_payee_from_memo(st) == res end)
  end

  test "it doesn't transform memos that are already clear" do
    ["IMPOSTO I.R.S./C. 000/000",
      "REFORCO DEPOSITO A PRAZO 000/000",
      "SEGURO MULTI-RISCOS-HABITACAO-CERTIF.: 000000000",
      "SEGURO VIDA-HABITACAO-CERTIF.: 000000000",
      "IMPOSTO DO SELO - 000000000-000-000",
      "JUROS DE EMPRESTIMO - 000000000-000-000",
      "AMORTIZACAO DE CAPITAL - 000000000-000-000",
      "JURO DP404/003 EUR 1.234,56 18AGO15/17AGO16 TANB 0,150%"]
    |> Enum.each(fn st -> assert get_payee_from_memo(st) == st end)
  end


end
