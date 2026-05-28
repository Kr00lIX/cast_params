defmodule CastParams.Plug do
  @moduledoc """
  Define `Plug` for casting params to types described in `CastParams.Schema`
  """
  @behaviour Plug
  alias CastParams.{Config, Error, NotFound, Type}

  @impl true
  def init({schema, config}), do: {schema, config}

  @impl true
  def call(conn, {schema, config}) do
    prepared_params = Enum.reduce(schema, conn.params, &prepare_param(&1, &2, config))
    %{conn | params: prepared_params}
  end

  @spec prepare_param(CastParams.Param.t(), map(), Config.t()) :: map() | no_return()
  defp prepare_param(%{names: names} = param, params, config) do
    case get_in(params, names) do
      nil ->
        handle_missing(param, params, config)

      raw_value ->
        case Type.cast(param.type, raw_value) do
          {:ok, value} ->
            put_in(params, names, value)

          {:error, reason} ->
            raise Error, "cannot cast #{path(names)} to #{inspect(param.type)}: #{inspect(reason)}"
        end
    end
  end

  defp handle_missing(%{required: true} = param, _params, _config) do
    raise %NotFound{message: "param #{path(param.names)} is required", field: param.names}
  end

  defp handle_missing(%{names: names, default: default}, params, _config) when not is_nil(default) do
    put_in(params, names, default)
  end

  defp handle_missing(%{names: names}, params, %Config{nulify: true}) do
    put_in(params, names, nil)
  end

  defp handle_missing(_param, params, _config), do: params

  defp path(names) when is_list(names), do: Enum.join(names, ".")
  defp path(name), do: to_string(name)
end
