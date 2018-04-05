# CastParams

Casting params in controllers

```elixir
defmodule ExampleController do
  cast_params(category_id: :integer) when action == :index
  cast_params(name: :string!, terms: :boolean!) when action == :create

  def index(conn, params) do

  end

  def create(conn, params) do

  end

end
```


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `cast_params` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:cast_params, "~> 0.0.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/cast_params](https://hexdocs.pm/cast_params).

