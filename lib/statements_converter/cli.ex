defmodule StatementsConverter.CLI do
  
  @default_files "*.csv"

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

  It returns a tuple with `{format, files}` or `:help` if help was given
  """

  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [help: :boolean, 
                                                format: :string],
                                     aliases: [h: :help, 
                                             f: :format]
                              )
    case parse do
      {[help: true], _, _}
        -> :help

      {[format: format], [files], _}
        -> {format, files}

      {[format: format], [], _}
        -> {format, @default_files}

      _ -> :help
    end
  end

end