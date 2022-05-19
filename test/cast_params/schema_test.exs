defmodule CastParams.SchemaTest do
  use ExUnit.Case
  doctest CastParams.Schema, import: true
  import CastParams.Schema

  alias CastParams.{Schema, Param, Error}

  describe "(simple definition)" do
    test "expect parse :integer param" do
      assert [param] = Schema.init(age: :integer)
      assert %Param{names: ["age"], type: :integer} == param

      assert [param] = Schema.init(age: :integer!)
      assert %Param{names: ["age"], type: :integer, required: true} == param
    end

    test "expect parse :boolean param" do
      assert [param] = Schema.init(terms: :boolean)
      assert %Param{names: ["terms"], type: :boolean} == param

      assert [param] = Schema.init(terms: :boolean!)
      assert %Param{names: ["terms"], type: :boolean, required: true} == param
    end

    test "expect parse :string param" do
      assert [param] = Schema.init(name: :string)
      assert %Param{names: ["name"], type: :string} == param

      assert [param] = Schema.init(name: :string!)
      assert %Param{names: ["name"], type: :string, required: true} == param
    end

    test "expect parse :float param" do
      assert [param] = Schema.init(weight: :float)
      assert %Param{names: ["weight"], type: :float} == param

      assert [param] = Schema.init(weight: :float!)
      assert %Param{names: ["weight"], type: :float, required: true} == param
    end

    test "expect parse :decimal param" do
      assert [param] = Schema.init(weight: :decimal)
      assert %Param{names: ["weight"], type: :decimal} == param

      assert [param] = Schema.init(weight: :decimal!)
      assert %Param{names: ["weight"], type: :decimal, required: true} == param
    end

    test "expect raise error for undefined types" do
      assert_raise Error, fn ->
        Schema.init(name: :invalid_type)
      end
    end
  end

  describe "(simple definition with namespace)" do
    test "expect parse namespace param" do
      assert [
               %Param{names: ["user", "age"], type: :integer},
               %Param{names: ["user", "name"], type: :string},
               %Param{names: ["category_id"], type: :integer, required: true}
             ] == Schema.init(user: [age: :integer, name: :string], category_id: :integer!)

      assert [
               %Param{names: ["user", "country", "id"], type: :integer},
               %Param{names: ["user", "country", "name"], type: :string},
               %Param{names: ["user", "name"], type: :string},
               %Param{names: ["category_id"], type: :integer, required: true}
             ] == Schema.init(user: [country: [id: :integer, name: :string], name: :string], category_id: :integer!)
    end
  end
end
