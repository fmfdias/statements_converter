defmodule StatementsConverter.Converters.BancoBPI do

  alias StatementsConverter.Converters.BancoBPI.XLS
  alias StatementsConverter.Converters.BancoBPI.XLSX

  def parse(file) do
    with :ok <- Xlsxir.extract(file, 0) do
      data = XLSX.parse
      Xlsxir.close
      data
    else
      _ -> XLS.parse(file)
    end
  end
end
