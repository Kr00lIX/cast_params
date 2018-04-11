defmodule CastParams.Param do
  @moduledoc false
  @type t :: %__MODULE__{
  }

  @enforce_keys [:name, :type]
  defstruct name: nil, type: nil, required: false
end
