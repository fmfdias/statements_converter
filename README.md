# StatementsConverter

This is an command line app I've built as an training app while reading Dave Thomas excelent [Programming Elixir](https://pragprog.com/book/elixir13/programming-elixir-1-3).

The tool converts bank statements to the QIF format.

Currently it only supports bank statement files from 2 Portuguese banks, [Banco BPI](http://bancobpi.pt/) and [Millennium BCP](http://www.millenniumbcp.pt).

I may add other Portuguese banks support in the near future, but please, do a pull request if you want to add more.

## Installation

### Building from source

#### Prerequisites

* [Elixir](http://elixir-lang.org/install.html)
* [Erlang](http://elixir-lang.org/install.html#installing-erlang)

Clone/Download the repo. On the repo folder run the following commands:

```
$> MIX_ENV=prod mix deps.get && mix escript.build && mix escript.install
```

### Executable

#### Prerequisites

* [Erlang](http://elixir-lang.org/install.html#installing-erlang)

Download the latest [release](https://github.com/fmfdias/statements_converter/releases/latest).
After it, paste it to a place in the $PATH environment variable. (e.g: /usr/opt/bin)
