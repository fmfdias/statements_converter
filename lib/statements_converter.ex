defmodule StatementsConverter do
  @supported_formats [bancobpi: true]

  def supported_formats do
    @supported_formats
  end

  def supported_format?(format) when is_atom(format) do
    Keyword.has_key?(supported_formats, format)
  end

  def supported_format?(format) when is_bitstring(format) do
    supported_format?(String.to_atom(format))
  end
end
