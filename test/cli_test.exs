defmodule CliTest do
  use ExUnit.Case
  doctest StatementsConverter.CLI

  import StatementsConverter.CLI, only: [parse_args: 1]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h",  "anything"]) == :help
    assert parse_args(["--help",  "anything"]) == :help
  end

  test "format option is mandatory and returns help if it isn't specified" do
    assert parse_args(["anything"]) == :help
    assert parse_args(["-f"]) == :help
    assert parse_args(["--format"]) == :help
  end

  test "format is correctly parsed and returns as the first tuple value" do
    assert parse_args(["--format", "test"]) == {"test", "*.csv"}
    assert parse_args(["-f", "test"]) == {"test", "*.csv"}
  end

  test "specified file is correctly parsed as second tuple value" do
    assert parse_args(["-f", "test", "test.csv"]) == {"test", "test.csv"}
  end

  test "files is not mandatory and returns the default *.csv" do
    assert parse_args(["-f", "test"]) == {"test", "*.csv"}
  end
end