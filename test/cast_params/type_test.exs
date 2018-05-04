defmodule CastParams.TypeTest do
  use ExUnit.Case, async: true
  use ExUnitProperties
  alias CastParams.Type

  doctest CastParams.Type, import: true

  describe "(custom type)" do
    defmodule Custom do
      @behaviour CastParams.Type
      def type, do: :custom
      def cast(_), do: {:ok, :cast}
    end
  end

  describe "(primitive type)" do
    test "expect cast :integer value" do
      check all num <- integer() do
        assert {:ok, num} == Type.cast(:integer, num)
      end
      assert {:ok, 1234} == Type.cast(:integer, "1234")
      assert {:error, _} = Type.cast(:integer, nil)
    end

    test "expect cast :string value" do
      assert {:ok, "example"} == Type.cast(:string, "example")
      assert {:ok, "1"} == Type.cast(:string, 1)
      assert {:ok, "true"} == Type.cast(:string, true)
      check all value <- binary() do
        assert {:ok, value} == Type.cast(:string, value)
      end
    end

    test "expect cast :boolean value" do
      assert {:ok, true} == Type.cast(:boolean, "true")
      assert {:ok, true} == Type.cast(:boolean, "1")
      assert {:ok, true} == Type.cast(:boolean, true)
      assert {:ok, false} == Type.cast(:boolean, "false")
      assert {:ok, false} == Type.cast(:boolean, "0")
      assert {:ok, false} == Type.cast(:boolean, false)
      assert {:error, :invalid_type} == Type.cast(:boolean, "")
      assert {:error, :invalid_type} == Type.cast(:boolean, "whatever")
    end

    test "expect cast :float value" do
      check all value <- float() do
        assert {:ok, value} == Type.cast(:float, value)
      end
      
      assert {:ok, 0.01} == Type.cast(:float, "0.01")
      assert {:ok, 1.0} == Type.cast(:float, "1.0")
      assert {:ok, 1.0} == Type.cast(:float, "1")
      assert {:ok, 1.0} == Type.cast(:float, 1)
      assert {:error, _reason} = Type.cast(:float, "1-09")
    end

    test "expect cast :decimal value" do
      assert {:ok, Decimal.new(1.0)} == Type.cast(:decimal, "1.0")
      assert {:ok, Decimal.new(0.01)} == Type.cast(:decimal, "0.01")
      assert {:ok, Decimal.new(1.0)} == Type.cast(:decimal, Decimal.new(1.0))
      assert {:ok, Decimal.new(0.01)} == Type.cast(:decimal, Decimal.new(0.01))
      assert {:error, _reason} = Type.cast(:decimal, nil)
    end

    test "expect cast :date value" do
    end

    test "expect cast :utc_datetime value" do
    end

    test "expect cast :naive_datetime value" do
    end

    test "expect cast :time value" do
    end
  end
end
