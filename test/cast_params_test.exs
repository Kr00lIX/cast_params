defmodule CastParamsTest do
  use ExUnit.Case
  doctest CastParams

  describe ".cast_params" do
    test "configure " do
      plug = CastParams.cast_params(category_id: :integer, terms: :boolean)

    end

    test "validate required " do
      plug = CastParams.cast_params([category_id: :integer!, terms: :boolean!])

    end
  end

end
