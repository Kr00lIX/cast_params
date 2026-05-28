defmodule CastParams.NotFound do
  @moduledoc """
  Exception raised when a required parameter is missing from the request.

  The `:field` key contains the list of nested names that identifies the parameter.
  """
  defexception [:message, :field]
end
