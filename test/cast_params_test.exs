defmodule CastParamsTest do
  use ExUnit.Case, async: true
  use CastParams
  doctest CastParams

  describe ".cast_params" do
    def plug(plug, {schema, _config}) do
      assert CastParams.Plug == plug
      schema
    end

    test "create call guard" do
      assert [%CastParams.Param{names: ["age"], required: false, type: :integer}] = cast_params(age: :integer)
    end
  end
end
