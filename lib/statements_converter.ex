defmodule StatementsConverter do
  @supported_formats [
    bancobpi: StatementsConverter.Converters.BancoBPI,
    milleniumbcp: StatementsConverter.Converters.MilleniumBCP
  ]

  @doc """
  Returns the list of supported formats
  """
  def supported_formats do
    @supported_formats
  end

  @doc """
  Checks if the passed format param is supported.
  Returns true if it's supported or false otherwise

  ## Example

    iex> StatementsConverter.supported_format?(:bancobpi)
    true
    
    iex> StatementsConverter.supported_format?("bancobpi")
    true
    
    iex> StatementsConverter.supported_format?(:notsupported)
    false

  """
  def supported_format?(format) when is_atom(format) do
    Keyword.has_key?(supported_formats(), format)
  end

  def supported_format?(format) when is_bitstring(format) do
    supported_format?(String.to_atom(format))
  end

  @doc """
  Gets the converted module for the format passed.
  Returns nil if the format is not supported.

  ## Example

    iex> StatementsConverter.get_converter(:bancobpi)
    StatementsConverter.Converters.BancoBPI
    
    iex> StatementsConverter.get_converter("bancobpi")
    StatementsConverter.Converters.BancoBPI
    
    iex> StatementsConverter.get_converter(:notsupported)
    nil

  """
  def get_converter(format) when is_atom(format) do
    Keyword.get(supported_formats(), format)
  end

  def get_converter(format) when is_bitstring(format) do
    get_converter(String.to_atom(format))
  end
end
