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
    config = CastParams.Config.configure(options)

    result = 
    if guards do
      quote location: :keep do
        plug CastParams.Plug, unquote(Macro.escape config) when unquote(guards)
      end    
    else
      quote location: :keep do
        plug CastParams.Plug, unquote(Macro.escape config)
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
