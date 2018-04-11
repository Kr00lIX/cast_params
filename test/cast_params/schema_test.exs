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

    test "expect parse :float param" do
      assert [param] = Schema.init(weight: :float)
      assert %Param{name: "weight", type: :float} == param

      assert [param] = Schema.init(weight: :float!)
      assert %Param{name: "weight", type: :float, required: true} == param
    end

    test "expect parse :decimal param" do
      assert [param] = Schema.init(weight: :decimal)
      assert %Param{name: "weight", type: :decimal} == param

      assert [param] = Schema.init(weight: :decimal!)
      assert %Param{name: "weight", type: :decimal, required: true} == param
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
        %Param{name: "user.age", type: :integer},
        %Param{name: "user.name", type: :string},
        %Param{name: "category_id", type: :integer, required: true}
      ] == Schema.init(user: [age: :integer, name: :string], category_id: :integer!)

      assert [
        %Param{name: "user.country.id", type: :integer},
        %Param{name: "user.country.name", type: :string},
        %Param{name: "user.name", type: :string},
        %Param{name: "category_id", type: :integer, required: true}
      ] == Schema.init(user: [country: [id: :integer, name: :string], name: :string], category_id: :integer!)
    end
  end
end
