defmodule CastParams do
  @moduledoc """
  Plug for casting request params to defined types.

  ## Usage

  ```elixir
  defmodule AccountController do
    use AppWeb, :controller
    use CastParams

    # define params types
    # :category_id - required integer param (raise CastParams.NotFound if not exists)
    # :weight - float param, set nil if doesn't exists
    cast_params category_id: :integer!, weight: :float

    # defining for show action
    # *:name* - is required string param
    # *:terms* - is boolean param
    cast_params name: :string!, terms: :boolean when action == :show
      
    # received prepared params
    def index(conn, %{"category_id" => category_id, "weight" => weight} = params) do
    end

    # received prepared params
    def show(conn, %{"category_id" => category_id, "terms" => terms, "weight" => weight} = params) do      
    end
  end
  ```

  ## Supported Types
    #{CastParams.Type.primitive_types() |> Enum.map(&inspect/1) |> Enum.join(", ")}

  """

  alias CastParams.{Schema, Plug}

  defmacro __using__(_opts \\ []) do
    quote do
      import CastParams
    end
  end

  @doc """
  Stores a plug to be executed as part of the plug pipeline.
  """
  defmacro cast_params(args)

  defmacro cast_params({:when, _, [options, guards]}) do
    cast_params(options, guards)
  end

  defmacro cast_params(options) do
    {params, guards} = detect_attached_guards(options)
    cast_params(params, guards)
  end

  defp cast_params(options, guards) do
    config = Schema.init(options)

    result =
      if guards do
        quote location: :keep do
          plug(Plug, unquote(Macro.escape(config)) when unquote(guards))
        end
      else
        quote location: :keep do
          plug(Plug, unquote(Macro.escape(config)))
        end
      end

    # result
    # |> IO.inspect
    # |> Macro.to_string
    # |> IO.puts

    result
  end

  # detect attached guard to the end of options list
  #  `cast_params id: :integer when action == :index`
  defp detect_attached_guards(args) do
    Enum.reduce(args, {[], nil}, fn
      {key, {:when, _env, [value, condition]}}, {ast, _guard} ->
        {[{key, value} | ast], condition}

      {key, value}, {ast, guard} ->
        {[{key, value} | ast], guard}
    end)
  end
end
