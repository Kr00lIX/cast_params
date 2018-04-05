defmodule CastParams.Param do

  @enforce_keys [:name, :type]
  defstruct [name: nil, type: nil, required: false]

end