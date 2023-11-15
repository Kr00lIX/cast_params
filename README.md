# CastParams
-----
[![Build Status][shield-travis]][travis-ci]
[![Coverage Status][shield-coveralls]][docs]
[![Version][shield-version]][hexpm]
[![License][shield-license]][hexpm]

CastParams is a powerful library for Elixir's [Plug][plug] that allows you to define parameter types and automatically cast incoming parameters to their respective types in a plug for `Phoenix.Controller` or `Plug.Router`. This simplifies the process of handling incoming parameters and reduces the amount of manual type checking and casting you need to do in your code.


## Features
* **Type Casting**: Automatically cast incoming parameters to their defined types. This eliminates the need for manual type checking and casting in your code.
* **Nullify Parameters**: If a parameter does not exist, it will be set to null. This prevents errors caused by undefined parameters.
* **Required Types**: You can mark a type as required by ending it with a `!`. If a required parameter does not exist, an exception will be raised.
* **Namespace Support**: CastParams supports namespaced parameters like `user[name]`.

## Usage

### Phoenix Framework

1. Add `use CastParams` inside your Phoenix controller or in `web.ex`. This will extend the controller module with the `cast_params/1` macro which allows you to define parameter types.
2. Use the `cast_params` macro to define the types for your parameters. You can define types for all actions or for specific actions.
3. In your action functions, you can now access the casted parameters directly from the params map.

Here is an example:
```elixir
defmodule AccountController do

  use AppWeb, :controller
  use CastParams
  
  # Define parameter types for all actions
  # :category_id is a required integer parameter (CastParams.NotFound will be raised if it does not exist)
  # :weight is a float parameter (will be set to nil if it does not exist)
  cast_params category_id: :integer!, weight: :float

  # Define parameter types for the show action
  # :name is a required string parameter
  # :terms is a boolean parameter  
  cast_params name: :string!, terms: :boolean when action == :show

  # Define parameter types for the create action
  # user[name] is a string parameter
  # user[subscribe] is a boolean parameter
  cast_params user: [name: :string, subscribe: :boolean] when action == :create

  # The index action receives the prepared parameters
  def index(conn, %{"category_id" => category_id, "weight" => weight} = params) do
    # Here you can use the casted parameters directly
    # For example, you might use the category_id to fetch a category from the database
    category = Repo.get(Category, category_id)
    # Then you might use the weight to filter products in that category
    products = Repo.all(from p in Product, where: p.category_id == ^category_id and p.weight <= ^weight)
    # Then render the index view with the products
    render(conn, "index.html", products: products)
  end

  # The show action also receives the prepared parameters
  def show(conn, %{"category_id" => category_id, "terms" => terms, "weight" => weight}) do      
    # Here you might use the category_id and terms to fetch a specific product
    product = Repo.get_by(Product, category_id: category_id, terms: terms)
    # Then render the show view with the product
    render(conn, "show.html", product: product)
  end

  # The create action receives the prepared parameters
  def create(conn, %{"user" => %{"name" => name, "subscribe" => subscribe}) do
        # Here you might use the name and subscribe parameters to create a new user
    user = User.changeset(%User{}, %{name: name, subscribe: subscribe})
    case Repo.insert(user) do
      {:ok, user} -> redirect(conn, to: user_path(conn, :show, user))
      {:error, changeset} -> render(conn, "new.html", changeset: changeset)
    end
  end
end
```

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
[Available in Hex](https://hex.pm/packages/cast_params), the package can be installed by adding `cast_params`to your list of dependencies in mix.exs:

```elixir
def deps do
  [
    {:cast_params, "~> 0.0.4"} 
  ]
end
```

## Common Issues and Solutions
If you encounter any issues while using CastParams, please check this section first. If your issue is not listed here, feel free to open an issue on the GitHub repository.

## Contribution
Contributions are always welcome! Feel free to send your PR with proposals, improvements, or corrections.


## License
This software is licensed under [the MIT license](LICENSE.md).
