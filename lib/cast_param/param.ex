defmodule CastParams.Param do
  @moduledoc false
  @type t :: %__MODULE__{
    name: String.t,
    type: CastParams.Type.t,
    required: boolean()
  }

  @enforce_keys [:name, :type]
  defstruct name: nil, type: nil, required: false
end
