defmodule CastParamsTest do
  use ExUnit.Case, async: true
  import CastParams
  doctest CastParams

  describe ".cast_params" do
    def plug(plug, options) do
      assert CastParams.Plug == plug
      options
    end

    test "create call guard" do
      assert [%CastParams.Param{name: "age", required: false, type: :integer}] = cast_params(age: :integer)
    end
  end
end
