defmodule StatementsConverter.Mixfile do
  use Mix.Project

  def project do
    [app: :statements_converter,
     version: "0.1.8",
     elixir: "~> 1.3",
     escript: escript_config(),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger,:timex,:xlsxir]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:floki, "~> 0.23.0"},
      {:timex, "~> 3.6.1"},
      # Workaround to issue when using escript described here: https://github.com/bitwalker/timex/issues/86
      {:tzdata, "~> 0.1.8", override: true},
      {:codepagex, "~> 0.1.4"},
      {:csv, "~> 2.3.0"},
      {:xlsxir, "~> 1.6.4"}
    ]
  end

  defp escript_config do
    [main_module: StatementsConverter.CLI]
  end
end
