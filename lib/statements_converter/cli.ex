defmodule StatementsConverter.CLI do
  
  @default_files "*.csv"

  import StatementsConverter, only: [supported_formats: 0,
                                     supported_format?: 1]

  @moduledoc """
​  Handle the command line parsing and the dispatch to​
​  to the correct parsers and converters
  """

  def run(argv) do
    parse_args(argv)
  end

  @doc """
  `argv` can be -h or --help which will

  Otherwise it will be the filename (optional) that defaults to every csv file
  with the options
  -f format of the input file

  It :help when help option is given or there's no valid options match
  It returns :invalid_format when the format given is not supported
  It returns a tuple with `{format, files}` when everything is ok.
  """

  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [help: :boolean, 
                                                format: :string],
                                     aliases: [h: :help, 
                                             f: :format]
                              )
    parse_options(parse)
  end

  defp parse_options({[help: true], _, _}), do: :help

  defp parse_options({[format: format], [files], _}) do
    if supported_format?(format) do
      {format, files}
    else
      :invalid_format
    end
  end

  defp parse_options({[format: format], [], errors}) do
    parse_options {[format: format], [@default_files], errors}
  end

  defp parse_options(_), do: :help

end