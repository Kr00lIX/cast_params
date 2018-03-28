defmodule CastParams.Plug do
  import Plug.Conn
  alias CastParams.Param

  def init(options) do
    options
  end

  def call(conn, options) do
    # Enum.reduce(conn.params, )
    for param <- options do
      Param.prepare(conn, param)
    end

    conn
  end

end