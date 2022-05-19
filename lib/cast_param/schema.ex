defmodule CastParams.Schema do
  @moduledoc """
  Defines a params schema for a plug.

  A params schema is just a keyword list where keys are the parameter name 
  and the value is either a valid `CastParams.Type` (ending with a `!` to mark the parameter as required).

  ## Example

      CastParams.Schema.init(age: :integer, terms: :boolean!, name: :string, weight: :float)

  """

  alias CastParams.{Param, Error, Type}

  @primitive_types Type.primitive_types()
  @required_to_type Enum.reduce(@primitive_types, %{}, &Map.put(&2, :"#{&1}!", &1))
  @required_names Map.keys(@required_to_type)

  @type t :: [{name :: atom(), Type.t()}]

  @doc """
  Init schema

  ## Examples
      iex> init(age: :integer)
      [%CastParams.Param{names: ["age"], type: :integer}]

      iex> init([age: :integer!])
      [%CastParams.Param{names: ["age"], type: :integer, required: true}]

      iex> init([terms: :boolean!, name: :string, age: :integer])
      [
        %CastParams.Param{names: ["terms"], type: :boolean, required: true},
        %CastParams.Param{names: ["name"], required: false, type: :string},
        %CastParams.Param{names: ["age"], required: false, type: :integer},
      ]
  """
  @spec init(options :: list()) :: [Param.t()]
  def init(options) when is_list(options) do
    options
    |> Enum.reduce([], &init_item(%Param{}, &1, &2))
    |> Enum.reduce([], fn param, acc ->
      updated_item =
        param
        |> Map.update!(:names, &Enum.reverse/1)

      [updated_item | acc]
    end)
  end

  defp init_item(param, {name, type}, acc) when is_atom(name) and is_atom(type) do
    updated_param =
      param
      |> parse_names(name)
      |> parse_type(type)

    [updated_param | acc]
  end

  defp init_item(param, {name, options}, acc) when is_list(options) do
    updated_param = parse_names(param, name)

    options
    |> Enum.reduce(acc, &init_item(updated_param, &1, &2))
  end

  defp parse_names(%{names: names} = param, name) when is_atom(name) do
    parsed_name = to_string(name)
    %{param | names: [parsed_name | names]}
  end

  @spec parse_type(Param.t(), atom()) :: Param.t()
  defp parse_type(param, type) when type in @primitive_types do
    Map.put(param, :type, type)
  end

  defp parse_type(param, raw_type) when raw_type in @required_names do
    param
    |> Map.put(:type, @required_to_type[raw_type])
    |> Map.put(:required, true)
  end

  defp parse_type(param, type) do
    raise Error, "Error invalid `#{type}` type for `#{param.names}` name."
  end
end
