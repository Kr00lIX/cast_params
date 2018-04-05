# CastParams
-----
[![Build Status](https://travis-ci.org/Kr00lIX/cast_params.svg?branch=master)](https://travis-ci.org/Kr00lIX/cast_params)
[![Hex pm](https://img.shields.io/hexpm/v/cast_params.svg?style=flat)](https://hex.pm/packages/cast_params)
[![Coverage Status](https://coveralls.io/repos/github/Kr00lIX/cast_params/badge.svg?branch=master)](https://coveralls.io/github/Kr00lIX/cast_params?branch=master)


Casting params in Phoenix controllers.

```elixir
defmodule AppWeb.ExampleController do
  use AppWeb, :controller
  use CastParams

  cast_params(category_id: :integer) when action == :index
  cast_params(name: :string!, terms: :boolean!) when action == :create

  def index(conn, %{"category_id" => category_id}) do
    # some code
  end

  def create(conn, %{"name" => name, "terms" => terms} = params) do
    # some code
  end
end
```


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `cast_params` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:cast_params, ">= 0.0.1"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/cast_params](https://hexdocs.pm/cast_params).

