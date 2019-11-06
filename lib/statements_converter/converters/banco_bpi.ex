defmodule StatementsConverter.Converters.BancoBPI do

  alias StatementsConverter.Converters.BancoBPI.XLS
  alias StatementsConverter.Converters.BancoBPI.XLSX

  def parse(file) do
    with {:ok, tid} <- Xlsxir.extract(file, 0) do
      data = XLSX.parse(tid)
      Xlsxir.close(tid)
      data
    else
      _ -> XLS.parse(file)
    end
  end
end
