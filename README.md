# StatementsConverter

This is an command line app I've built as an training app while reading Dave Thomas excelent [Programming Elixir](https://pragprog.com/book/elixir13/programming-elixir-1-3).

The tool converts bank statements to the QIF format.

Currently it only supports bank statement files from 2 Portuguese banks, [Banco BPI](https://www.bancobpi.pt) and [Millennium BCP](https://www.millenniumbcp.pt).

I may add other Portuguese banks support in the near future, but please, do a pull request if you want to add more.

## Installation

### Building from source

#### Prerequisites

* [Elixir](https://elixir-lang.org/install.html)
* [Erlang](https://elixir-lang.org/install.html#installing-erlang)

Clone/Download the repo. On the repo folder run the following commands:

```
$> (export MIX_ENV=prod; mix deps.get && mix escript.build && mix escript.install)
```

### Executable

#### Prerequisites

* [Erlang](https://elixir-lang.org/install.html#installing-erlang)

Download the latest [release](https://github.com/fmfdias/statements_converter/releases/latest).
After it, paste it to a place in the $PATH environment variable. (e.g: /usr/opt/bin)

### MIX

#### Prerequisites

* [Elixir >= 1.4](https://elixir-lang.org/install.html)
* [Erlang](https://elixir-lang.org/install.html#installing-erlang)

```
$> mix escript.install https://github.com/fmfdias/statements_converter/releases/download/0.1.7/statements_converter
```
