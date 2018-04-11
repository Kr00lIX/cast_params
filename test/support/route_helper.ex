defmodule RouterHelper do
  @moduledoc """
  Conveniences for testing routers and controllers.
  Must not be used to test endpoints as it does some
  pre-processing (like fetching params) which could
  skew endpoint tests.
  """

  import Plug.Test

  defmacro __using__(_) do
    quote do
      use Plug.Test
      import RouterHelper
    end
  end

  def call(router, verb, path, params \\ nil, script_name \\ []) do
    verb
    |> conn(path, params)
    |> Plug.Conn.fetch_query_params()
    |> Map.put(:script_name, script_name)
    |> router.call(router.init([]))
  end

  def call_params(router, params \\ nil) do
    %{params: params} = call(router, :get, "/", params)
    params
  end

  def action(controller, verb, action, params \\ nil) do
    conn = conn(verb, "/", params) |> Plug.Conn.fetch_query_params()
    controller.call(conn, controller.init(action))
  end

  def action_params(controller, action, params) do
    %{params: params} = action(controller, :get, action, params)
    params
  end
end
