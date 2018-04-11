defmodule CastParams.ConfigTest do
  use ExUnit.Case
  doctest CastParams.Config, import: true
  import CastParams.Config

  alias CastParams.{Config, Param, Error}

  describe "(simple definition)" do
    test "expect parse :integer param" do
      assert [param] = Config.configure(age: :integer)
      assert %Param{name: "age", type: :integer} == param

      assert [param] = Config.configure(age: :integer!)
      assert %Param{name: "age", type: :integer, required: true} == param
    end

    test "expect parse :boolean param" do
      assert [param] = Config.configure(terms: :boolean)
      assert %Param{name: "terms", type: :boolean} == param

      assert [param] = Config.configure(terms: :boolean!)
      assert %Param{name: "terms", type: :boolean, required: true} == param
    end

    test "expect parse :string param" do
      assert [param] = Config.configure(name: :string)
      assert %Param{name: "name", type: :string} == param

      assert [param] = Config.configure(name: :string!)
      assert %Param{name: "name", type: :string, required: true} == param
    end

    test "expect raise error for undefined types" do
      assert_raise Error, fn ->
        Config.configure(name: :invalid_type)
      end
    end
  end
end
