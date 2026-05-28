# TODO

* Rename `CastParams.NotFound` to `CastParams.RequiredParam` (keep alias for one release).
* Support typed maps in schemas: `categories: %{integer: :string}`.
* Built-in validators (`min:`, `max:`, `format:`).
* Module-level schema definition:
  ```elixir
  defmodule UserSearch do
    use CastParams.Schema, name: :string, age: :float!
  end

  defmodule UsersController do
    use CastParams
    cast_params UserSearch when action == :index
  end
  ```
* Composite types (`{:array, :integer}`, `{:map, :string}`).
</content>
