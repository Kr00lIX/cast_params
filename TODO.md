# TODO
* Rename NotFound to RequiredParam exception
* cast_params `categories: %{integer: :string}`
* Add interface for defining custom types 
* Add full format for defining additional params 
  ```elixir
  cast_params [category_id: %{type: :integer, required: true, default: true}]
  ```
* Add default value option
* Defining schema in separate module
```
defmodule UserSearch do
  use CastParams.Schema, [
    name: :string,
    age: float!
  ]
end

defmodule UsersController do
  use CastParams

  cast_params UserSearch when action == :index
end
```
* Add simple validation
* Add custom validators
* Me in id place
* Add date type type: :date, format: "YYYY-MM-DD"
* Add utc_datetime type
* Add naive_datetime type
* Add time type
