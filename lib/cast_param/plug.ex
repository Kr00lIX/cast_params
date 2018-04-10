defmodule CastParams.Plug do
  @behaviour Plug
  alias CastParams.{Type, NotFound, Error}

  def init(options) do
    config = []
    {options, config}
  end

  def call(conn, {options, _config}) do
    prepared_params = Enum.reduce(options, conn.params, &prepare/2)

    Map.put(conn, :params, prepared_params)
  end

  @spec prepare(CastParams.Param.t, map()) :: map() | no_return()
  defp prepare(param, params) do
    raw_value = params[param.name]
    cond do
      Map.has_key?(params, param.name) ->
        Type.cast(param.type, raw_value)
        |> case do
          {:ok, value} -> 
            Map.put(params, param.name, value)

          {:error, reason} ->
            raise Error, "Error casting `raw_value` to `#{param.name}` #{param.type} : #{inspect reason}"
        end
        
      param.required ->
        # todo: change to error
        raise %NotFound{message: "Error #{param.name} required", field: param.name}

      true ->
        #todo: move to call
        
        # set default param to nil
        Map.put(params, param.name, nil)
    end
  end
end
