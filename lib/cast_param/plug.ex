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

  @spec prepare(CastParams.Param.t(), map()) :: map() | no_return()
  defp prepare(%{names: names}=param, params) do
    raw_value = get_param(params, names)

    cond do
      raw_value != nil ->
        Type.cast(param.type, raw_value)
        |> case do
          {:ok, value} ->
            update_param(params, names, value)

          {:error, reason} ->
            raise Error, "Error casting `raw_value` to `#{names}` #{param.type} : #{inspect(reason)}"
        end

      param.required ->
        # todo: change to error
        raise %NotFound{message: "Error #{names} required", field: param.names}

      true ->
        # todo: move to call

        # set default param to nil
        update_param(params, names, nil)
    end
  end

  defp get_param(params, keys) do
    get_in params, keys
  end

  defp update_param(params, keys, value) do
    put_in(params, keys, value)
  end
end
