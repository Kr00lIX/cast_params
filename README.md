[CastParams][docs]
-----
[![Build Status][shield-travis]][travis-ci]
[![Coverage Status][shield-coveralls]][docs]
[![Version][shield-version]][hexpm]
[![License][shield-license]][hexpm]


Easily define [Plug][plug]'s params types and cast incoming params to their types in a plug for `Phoenix.Controller` or `Plug.Router`.


## Features
* Casting incoming params to defined types
* Nulify params if not exists
* Raise exception for required types (types ending with a `!`)
* Supports namespace for params like. (`user: [name: :string]` prepare params from `user[name]`)

## Usage

### Phoenix Framework
Put `use CastParams` inside Phoenix controller or add it into `web.ex`. It will extend controller module with `cast_params/1` macro which allows to define param's types. 

```elixir
  defmodule AccountController do
    use AppWeb, :controller
    use CastParams
    
    # Defining params types for all actions
    # :category_id - required integer param (raise CastParams.NotFound if not exists)
    # :weight - float param, set nil if doesn't exists
    cast_params category_id: :integer!, weight: :float

    # Defining for show action
    # :name - is required string param
    # :terms - is boolean param
    cast_params name: :string!, terms: :boolean when action == :show
      
    # Defining for create action
    # user[name] - string value
    # user[subscribe] - boolean value
    cast_params user: [name: :string, subscribe: :boolean] when action == :create

    # received prepared params
    def index(conn, %{"category_id" => category_id, "weight" => weight} = params) do
    end

    # received prepared params
    def show(conn, %{"category_id" => category_id, "terms" => terms, "weight" => weight}) do      
    end

    def create(conn, %{"user" => %{"name" => name, "subscribe" => subscribe}) do
    end
  end
```

Documentation can be found at [https://hexdocs.pm/cast_params][docs].

### Other Plug.Router Apps
For other applications using `Plug.Router`, call the `cast_params` anytime after calling the `:match` and `:dispatch` plugs:

```elixir
defmodule MyApp.Router do
  use Plug.Router
  use CastParams
  plug :match
  plug :dispatch

  cast_params(category_id: :integer, terms: :boolean)
  cast_params(name: :string)

  get("/", do: send_resp(conn, 200, "ok"))
end
```

## Supported Types
Each type can ending with a `!` to mark the parameter as required.

* *`:boolean`*
* *`:integer`* 
* *`:string`* 
* *`:float`* 
* *`:decimal`*


## Installation

[Available in Hex](https://hex.pm/packages/cast_params), the package can be installed as:

Add `cast_params` to your list of dependencies in mix.exs:

```elixir
def deps do
  [
    {:cast_params, ">= 0.0.3"} 
  ]
end
```

## Contribution
Feel free to send your PR with proposals, improvements or corrections 😉.

## License
This software is licensed under [the MIT license](LICENSE.md).

  [shield-version]:   https://img.shields.io/hexpm/v/cast_params.svg
  [shield-license]:   https://img.shields.io/hexpm/l/cast_params.svg
  [shield-downloads]: https://img.shields.io/hexpm/dt/cast_params.svg
  [shield-travis]:    https://img.shields.io/travis/Kr00lIX/cast_params.svg
  [shield-coveralls]:     https://img.shields.io/coveralls/github/Kr00lIX/cast_params.svg

  [travis-ci]:        https://travis-ci.org/Kr00lIX/cast_params
  [coveralls-ci]:     https://coveralls.io/github/Kr00lIX/cast_params?branch=master
  [docs]:             https://hexdocs.pm/cast_params/

  [license]:          https://opensource.org/licenses/MIT
  [hexpm]:            https://hex.pm/packages/cast_params
  [plug]:             https://github.com/elixir-lang/plug

  [github-fork]:      https://github.com/Kr00lIX/cast_params/fork
  