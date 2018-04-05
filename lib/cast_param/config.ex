defmodule CastParams.Config do
  alias CastParams.{Param, Error, Type}

  @primitive_types Type.primitive_types
  @required_to_type Enum.reduce(@primitive_types, %{}, &Map.put(&2, :"#{&1}!", &1))
  @required_names Map.keys(@required_to_type)

  def configure(options) do
    Enum.map(options, &config_param/1)
  end

  defp config_param({name, raw_type}) do
    parse(name, raw_type)
  end
 
  defp parse(name, raw_type) when raw_type in @primitive_types do
    %Param{
      name: parse_name(name),
      type: raw_type
    }
  end
  defp parse(name, raw_type) when raw_type in @required_names do
    %Param{
      name: parse_name(name), 
      type: @required_to_type[raw_type], 
      required: true
    }
  end
  defp parse(name, raw_type) do
    raise Error, "Error invalid `#{raw_type}` type for `#{name}` name."
  end

  defp parse_name(name) do
    to_string(name)
  end
end