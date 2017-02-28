defmodule StatementsConverter.CLI do

  @default_files "{*.csv,*.xls}"

  alias StatementsConverter.QIF
  import StatementsConverter, only: [supported_formats: 0,
                                     supported_format?: 1]

  @moduledoc """
​  Handle the command line parsing and the dispatch to​
​  to the correct parsers and converters
  """

  def main(argv) do
    argv
    |> parse_args
    |> process
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

  @doc """
  Processes the parse_options results

  It prints the help info when the param value is :help
  It prints the help info when the param value is :invalid_format
  It processes the files in the specified format when param is a tuple
  with the format and the files
  """
  def process(:help) do
    IO.puts """
    usage: statements_converter -f <file format> [files | #{@default_files}]
    """
    print_supported_formats()
  end

  def process(:invalid_format) do
    IO.puts "Invalid format specified"
    print_supported_formats()
  end

  def process({format, files}) do
    converter = StatementsConverter.get_converter(format)
    Path.wildcard(files)
    |> Stream.map(&{&1, converter.parse(&1)})
    |> Enum.each(&write_qif/1)
  end

  def write_qif({original_filename, transactions}) do
    replace_ext = Regex.compile! "#{Path.extname(original_filename)}$"
    new_file_name = String.replace(original_filename, replace_ext, ".qif")
    file = File.open!(new_file_name, [:write])
    try do
      QIF.write transactions, file
    after
      File.close(file)
    end
  end

  defp print_supported_formats do
    IO.write """
    List of valid formats:
    """
    supported_formats()
    |> Enum.each(fn {f,_} -> IO.puts Atom.to_string(f) end)
  end

end
