defmodule CastParams.Type do

  alias CastParams.Error

  @primitive_types [:boolean, :integer, :string]

  def primitive_types(), do: @primitive_types
  
  def cast(type, value) do
    do_cast(type, value)
  end

  defp do_cast(:integer, value) when is_integer(value),
  do: value
  defp do_cast(:integer, value) when is_binary(value) and value != "",
  do:  String.to_integer(value)
  # ArgumentError

  defp do_cast(:boolean, value) when value in ~w(true 1), do: true
  defp do_cast(:boolean, value) when value in ~w(false 0), do: false
  
  defp do_cast(:string, value) when is_binary(value), do: value

  defp do_cast(type, value) do
    raise Error, message: "Error cast `#{inspect value}` value to #{inspect type}"
  end
end