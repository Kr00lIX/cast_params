defmodule CastParams.Plug do
  @behaviour Plug
  alias CastParams.{Type, NotFound}

  def init(options) do
    options
  end

  def call(conn, options) do
    prepared_params = Enum.reduce(options, conn.params, &prepare/2)
  
    Map.put conn, :params, prepared_params
  end

  defp prepare(param, params) do
    cond do
      Map.has_key?(params, param.name) ->
        value = Type.cast(param.type, params[param.name])      
        Map.put params, param.name, value
      
      param.required ->
        raise %NotFound{message: "Error #{param.name} required", field: param.name}
      
      true ->
        # set default param to nil
        Map.put params, param.name, nil
    end
  end

end