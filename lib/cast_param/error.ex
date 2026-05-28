defmodule CastParams.Error do
  @moduledoc """
  Generic exception raised by `CastParams` when a parameter cannot be cast to its declared type.
  """
  defexception [:message]
end
