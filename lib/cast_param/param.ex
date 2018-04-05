defmodule CastParams.Param do
  alias CastParams.{Type, Param, Error}

  @enforce_keys [:name, :type]
  defstruct [name: nil, type: nil, required: false]

end