defmodule StatementsConverter.Converters.BancoBPI do

  alias StatementsConverter.Converters.BancoBPI.XLS

  def parse(file) do
    XLS.parse(file)
  end
end
