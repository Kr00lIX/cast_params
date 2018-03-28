defmodule CastParams do
  @moduledoc """
  Plug for casting request params to defined types.

  ## Usage
  ```
  defmodule AccountController do
    cast_params [category_id: :integer, terms: :boolean!] when action == :show

    # support namespace
    cast_params [user: [category_id: :integer, terms: :boolean!]] when action == :user

    
    def show(conn, %{category_id: category_id, terms: terms}) do
      
    end
  end
  ```

  """

  defmacro __using__(_opts) do
    quote do
      import CastParams
    end     
  end

  defmacro cast_params(options) do
    # todo parse when relation
    result = 
    options
    |> IO.inspect(label: "cast params")
    |> CastParams.Config.configure()
    |> IO.inspect(label: "parse params")
    
    quote do
      unquote(options)
      |> CastParams.Config.configure()
    end

    # parse params and check, validate syntax

    # create plug to convert params
  end

  def configure!(options) do
    IO.inspect(options, label: "configure")

    options
  end

end
