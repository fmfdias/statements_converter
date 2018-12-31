defmodule StatementsConverter.Converters.Common do
  def get_payee_from_memo(memo) do
    memo
    |> String.replace(~r/^MMD\d{7}\s*/, "")
    |> String.replace(~r/^MMD\d{4}(\sNET\sMMD)?\s*/, "")
    |> String.replace(~r/^MMD\s*/, "")
    |> String.replace(~r/^DD\s?PT\d{8}\s*/, "")
    |> String.replace(~r/^(\d{2}\/\d{2})\s*/, "")
    |> String.replace(~r/^(COBR(ANCA\s*DD)?\s*SEPA\s*(\w|\d)*\s*)/, "")
    |> String.replace(~r/^(COBRANCA\s*)/, "")
    |> String.replace(~r/^(COMPRA\s*)(\d{4}\s*)?/, "")
    |> String.replace(~r/^(DEVOLUCAO\s*)/, "")
    |> String.replace(~r/ELEC\s\d+\/\d{2}\s*/, "")
    |> String.replace(~r/^TRA\.RECEB\s(\w+\sP\/ORD\.DE\s*)?/, "")
    |> String.replace(~r/\s*CS$/, "")
    |> String.replace(~r/^TRF\s(\d+\s)?DE\s*/, "")
    |> String.replace(~r/^TRF\s\d+\sP\/\s(\w*\d+(\.|\s))+/, "")
    |> String.replace(~r/^TRF\sMB\sWAY(\s\d+)?\sDE\s/, "")
    |> String.replace(~r/^TRF\sMB\sWAY\sP\/\s/, "")
    |> String.replace(~r/^TRANSF\.\sMB\sWAY\s(ELEC\s\d{7}\/\d{2}\s)?P\/TLM\s+/, "")
    |> String.replace(~r/^TRF\.\sP\/O\s*/, "")
    |> String.replace(~r/^TRF\sP2P\s*/, "")
    |> String.replace(~r/^TRF\sINT\s*/, "")
    |> String.replace(~r/^TRF\s*/, "")
    |> String.replace(~r/\s*$/, "")
    |> String.replace(~r/\s+/, " ")
  end

  def parse_pt_date(""), do: nil

  def parse_pt_date(nil), do: nil

  def parse_pt_date(text) do
    text
    |> String.replace("/","-")
    |> Timex.parse!("{0D}-{0M}-{YYYY}")
  end

  def parse_iso_8601_date(""), do: nil

  def parse_iso_8601_date(nil), do: nil

  def parse_iso_8601_date(text) do
    text
    |> Timex.parse!("{YYYY}-{0M}-{0D}")
  end
end
