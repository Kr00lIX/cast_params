defmodule CastParams.Plug do
  @moduledoc """
  Define `Plug` for casting params to types described in `CastParams.Schema`
  """
  @behaviour Plug
  alias CastParams.{Type, NotFound, Error, Config}

  def init({schema, config}) do
    {schema, config}
  end

  def call(conn, {schema, config}) do
    prepared_params = Enum.reduce(schema, conn.params, &prepare_param(&1, &2, config))

    Map.put(conn, :params, prepared_params)
  end

  @spec prepare_param(CastParams.Param.t(), map(), Config.t()) :: map() | no_return()
  defp prepare_param(%{names: names} = param, params, config) do
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
        raise %NotFound{message: "Error #{names} required", field: param.names}

      config.nulify ->
        update_param(params, names, nil)

      true ->
        params
    end
  end

  defp get_param(params, keys) do
    get_in(params, keys)
  end

  defp update_param(params, keys, value) do
    put_in(params, keys, value)
  end
end
