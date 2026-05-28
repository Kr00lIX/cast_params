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
    property "expect cast :integer value" do
      check all(num <- integer()) do
        assert {:ok, num} == Type.cast(:integer, num)
      end

      assert {:ok, 1234} == Type.cast(:integer, "1234")
      assert {:error, _} = Type.cast(:integer, nil)
    end

    property "expect cast :string value" do
      assert {:ok, "example"} == Type.cast(:string, "example")
      assert {:ok, "1"} == Type.cast(:string, 1)
      assert {:ok, "true"} == Type.cast(:string, true)

      check all(value <- binary()) do
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

    property "expect cast :float value" do
      check all(value <- float()) do
        assert {:ok, value} == Type.cast(:float, value)
      end

      assert {:ok, 0.01} == Type.cast(:float, "0.01")
      assert {:ok, 1.0} == Type.cast(:float, "1.0")
      assert {:ok, 1.0} == Type.cast(:float, "1")
      assert {:ok, 1.0} == Type.cast(:float, 1)
      assert {:error, _reason} = Type.cast(:float, "1-09")
    end

    test "expect cast :decimal value" do
      assert {:ok, Decimal.new("1.0")} == Type.cast(:decimal, "1.0")
      assert {:ok, Decimal.from_float(0.01)} == Type.cast(:decimal, "0.01")
      assert {:ok, Decimal.from_float(1.0)} == Type.cast(:decimal, Decimal.from_float(1.0))
      assert {:ok, Decimal.from_float(0.01)} == Type.cast(:decimal, Decimal.from_float(0.01))
      assert {:error, _reason} = Type.cast(:decimal, nil)
    end

    test "expect cast :date value" do
      assert {:ok, ~D[2024-01-15]} == Type.cast(:date, "2024-01-15")
      assert {:ok, ~D[2024-01-15]} == Type.cast(:date, ~D[2024-01-15])
      assert {:error, _reason} = Type.cast(:date, "not a date")
      assert {:error, _reason} = Type.cast(:date, nil)
    end

    test "expect cast :utc_datetime value" do
      assert {:ok, ~U[2024-01-15 12:34:56Z]} == Type.cast(:utc_datetime, "2024-01-15T12:34:56Z")
      assert {:ok, ~U[2024-01-15 12:34:56Z]} == Type.cast(:utc_datetime, ~U[2024-01-15 12:34:56Z])
      assert {:error, _reason} = Type.cast(:utc_datetime, "no offset")
      assert {:error, _reason} = Type.cast(:utc_datetime, nil)
    end

    test "expect cast :naive_datetime value" do
      assert {:ok, ~N[2024-01-15 12:34:56]} == Type.cast(:naive_datetime, "2024-01-15T12:34:56")
      assert {:ok, ~N[2024-01-15 12:34:56]} == Type.cast(:naive_datetime, ~N[2024-01-15 12:34:56])
      assert {:error, _reason} = Type.cast(:naive_datetime, "garbage")
      assert {:error, _reason} = Type.cast(:naive_datetime, nil)
    end

    test "expect cast :time value" do
      assert {:ok, ~T[12:34:56]} == Type.cast(:time, "12:34:56")
      assert {:ok, ~T[12:34:56]} == Type.cast(:time, ~T[12:34:56])
      assert {:error, _reason} = Type.cast(:time, "25:00:00")
      assert {:error, _reason} = Type.cast(:time, nil)
    end
  end

  describe "(custom module type)" do
    defmodule UpcaseString do
      @behaviour CastParams.Type
      def type, do: :string
      def cast(value) when is_binary(value), do: {:ok, String.upcase(value)}
      def cast(_), do: {:error, :invalid}
    end

    test "casts via custom module" do
      assert {:ok, "HELLO"} == Type.cast(UpcaseString, "hello")
      assert {:error, :invalid} == Type.cast(UpcaseString, 123)
    end

    test "returns :invalid_type for module without cast/1" do
      defmodule NoCast do
      end

      assert {:error, :invalid_type} == Type.cast(NoCast, "x")
    end
  end
end
