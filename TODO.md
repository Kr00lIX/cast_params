# TODO
* Rename NotFound to RequiredParam exception
* Add interface for defining custom types
* Add full format for defining additional params 
  ```
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

