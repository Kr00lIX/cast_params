defmodule CastParams.SchemaTest do
  use ExUnit.Case
  doctest CastParams.Schema, import: true
  import CastParams.Schema

  alias CastParams.{Schema, Param, Error}

  describe "(simple definition)" do
    test "expect parse :integer param" do
      assert [param] = Schema.init(age: :integer)
      assert %Param{name: "age", type: :integer} == param

      assert [param] = Schema.init(age: :integer!)
      assert %Param{name: "age", type: :integer, required: true} == param
    end

    test "expect parse :boolean param" do
      assert [param] = Schema.init(terms: :boolean)
      assert %Param{name: "terms", type: :boolean} == param

      assert [param] = Schema.init(terms: :boolean!)
      assert %Param{name: "terms", type: :boolean, required: true} == param
    end

    test "expect parse :string param" do
      assert [param] = Schema.init(name: :string)
      assert %Param{name: "name", type: :string} == param

      assert [param] = Schema.init(name: :string!)
      assert %Param{name: "name", type: :string, required: true} == param
    end

    test "expect raise error for undefined types" do
      assert_raise Error, fn ->
        Schema.init(name: :invalid_type)
      end
    end
  end
end
