defmodule CastParams.Schema do
  @moduledoc """
  Defines a params schema for a plug.

  A params schema is just a keyword list where keys are the parameter name
  and the value is either a valid `CastParams.Type` (ending with a `!` to mark the parameter as required).

  ## Example

      CastParams.Schema.init(age: :integer, terms: :boolean!, name: :string, weight: :float)

  """

  alias CastParams.{Error, Param, Type}

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

      iex> init([category_id: %{type: :integer, required: true, default: 0}])
      [%CastParams.Param{names: ["category_id"], type: :integer, required: true, default: 0}]
  """
  @spec init(options :: list()) :: [Param.t()]
  def init(options) when is_list(options) do
    options
    |> Enum.reduce([], &init_item(%Param{}, &1, &2))
    |> Enum.map(&Map.update!(&1, :names, fn names -> Enum.reverse(names) end))
    |> Enum.reverse()
  end

  defp init_item(param, {name, type}, acc) when is_atom(name) and is_atom(type) do
    updated_param =
      param
      |> parse_names(name)
      |> parse_type(type)

    [updated_param | acc]
  end

  defp init_item(param, {name, {:%{}, _meta, kw}}, acc) when is_atom(name) and is_list(kw) do
    init_item(param, {name, Map.new(kw)}, acc)
  end

  defp init_item(param, {name, options}, acc) when is_atom(name) and is_map(options) do
    updated_param =
      param
      |> parse_names(name)
      |> parse_options(options)

    [updated_param | acc]
  end

  defp init_item(param, {name, options}, acc) when is_atom(name) and is_list(options) do
    updated_param = parse_names(param, name)
    Enum.reduce(options, acc, &init_item(updated_param, &1, &2))
  end

  defp parse_names(%{names: names} = param, name) when is_atom(name) do
    %{param | names: [to_string(name) | names]}
  end

  defp parse_options(param, %{type: type} = options) do
    param
    |> parse_type(type)
    |> Map.put(:required, Map.get(options, :required, false))
    |> Map.put(:default, Map.get(options, :default))
  end

  defp parse_options(param, options) do
    raise Error, "missing `:type` key in options for #{inspect(param.names)}: #{inspect(options)}"
  end

  @spec parse_type(Param.t(), atom()) :: Param.t()
  defp parse_type(param, type) when type in @primitive_types do
    %{param | type: type}
  end

  defp parse_type(param, raw_type) when raw_type in @required_names do
    %{param | type: @required_to_type[raw_type], required: true}
  end

  defp parse_type(param, type) when is_atom(type) do
    Code.ensure_loaded(type)

    if function_exported?(type, :cast, 1) do
      %{param | type: type}
    else
      raise Error, "invalid type `#{inspect(type)}` for `#{inspect(param.names)}` param."
    end
  end
end
