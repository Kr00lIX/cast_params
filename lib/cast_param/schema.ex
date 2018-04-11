defmodule CastParams.Schema do

  alias CastParams.{Param, Error, Type}

  @primitive_types Type.primitive_types()
  @required_to_type Enum.reduce(@primitive_types, %{}, &Map.put(&2, :"#{&1}!", &1))
  @required_names Map.keys(@required_to_type)

  @doc """
  Init schema

  ## Examples
      iex> init([age: :integer])
      [%CastParams.Param{name: "age", type: :integer}]

      iex> init([age: :integer!])
      [%CastParams.Param{name: "age", type: :integer, required: true}]

      iex> init([terms: :boolean!, name: :string, age: :integer])
      [
        %CastParams.Param{name: "terms", type: :boolean, required: true},
        %CastParams.Param{name: "name", required: false, type: :string},
        %CastParams.Param{name: "age", required: false, type: :integer},
      ]
  """
  @spec init(options :: list()) :: [Param.t]
  def init(options) when is_list(options) do
    # Enum.into(options, %{})
    options
    |> Enum.reduce([], &init_item(%Param{}, &1, &2))
    |> Enum.reverse()
  end

  defp init_item(param, {name, type}, acc) when is_atom(name) and is_atom(type) do
    updated_param = param
    |> parse_name(name)
    |> parse_type(type)

    [updated_param | acc]
  end
  defp init_item(param, {name, options}, acc) when is_list(options) do
    updated_param = parse_name(param, name)

    options
    # Enum.into(options, %{})
    |> Enum.reduce(acc, &init_item(updated_param, &1, &2))
  end

  # @spec init_param({atom() | String.t, atom()}, list()) :: Param.t | no_return()
  # defp init_param({name, options}, acc) when is_list(options) do
  #   Enum.into(options, %{})

  #   parse(name, raw_type)
  # end
  # defp init_param({name, raw_type}, acc) do
  #   param = parse(name, raw_type)
  #   [param | acc]
  # end


  # @spec init_param({atom() | String.t, atom()}, list()) :: Param.t | no_return()
  # defp init_param({name, options}, acc) when is_list(options) do
  #   Enum.into(options, %{})

  #   parse(name, raw_type)
  # end
  # defp init_param({name, raw_type}, acc) do
  #   param = parse(name, raw_type)
  #   [param | acc]
  # end

  
  defp parse_name(%{name: init_name}=param, name) when is_atom(name) do
    parsed_name = to_string(name)
    # updated_name = if init_name, do: "#{init_name}.#{parsed_name}", else: parsed_name
    updated_name = init_name && "#{init_name}.#{parsed_name}" || parsed_name
    Map.put(param, :name, updated_name)
  end

  @spec parse_type(Param.t, atom()) :: Param.t
  defp parse_type(param, type) when type in @primitive_types do
    Map.put(param, :type, type)
  end
  defp parse_type(param, raw_type) when raw_type in @required_names do
    param
    |> Map.put(:type, @required_to_type[raw_type])
    |> Map.put(:required, true)
  end
  defp parse_type(param, type) do
    raise Error, "Error invalid `#{type}` type for `#{param.name}` name."
  end
end
