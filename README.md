# CastParams
-----
[![Build Status](https://travis-ci.org/Kr00lIX/cast_params.svg?branch=master)](https://travis-ci.org/Kr00lIX/cast_params)
[![Hex pm](https://img.shields.io/hexpm/v/cast_params.svg?style=flat)](https://hex.pm/packages/cast_params)
[![Coverage Status](https://coveralls.io/repos/github/Kr00lIX/cast_params/badge.svg?branch=master)](https://coveralls.io/github/Kr00lIX/cast_params?branch=master)


Casting params in Phoenix controllers.

```elixir
  defmodule AccountController do
    use AppWeb, :controller
    use CastParams

    # define params types
    # :category_id - required integer param (raise CastParams.NotFound if not exists)
    # :weight - float param, set nil if doesn't exists
    cast_params category_id: :integer!, weight: :float

    # defining for show action
    # *:name* - is required string param
    # *:terms* - is boolean param
    cast_params name: :string!, terms: :boolean when action == :show
      
    # received prepared params
    def index(conn, %{"category_id" => category_id, "weight" => weight} = params) do
    end

    # received prepared params
    def show(conn, %{"category_id" => category_id, "terms" => terms, "weight" => weight} = params) do      
    end
  end
  ```

Documentation can be found at [https://hexdocs.pm/cast_params](https://hexdocs.pm/cast_params/).


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


## License
This software is licensed under [the MIT license](LICENSE.md).