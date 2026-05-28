defmodule CastParams.Param do
  @moduledoc false

  @type t :: %__MODULE__{
          names: [String.t()],
          type: CastParams.Type.t(),
          required: boolean(),
          default: term()
        }

  defstruct names: [], type: nil, required: false, default: nil
end
