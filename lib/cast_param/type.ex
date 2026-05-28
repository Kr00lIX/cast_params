defmodule CastParams.Type do
  @moduledoc """
  Define casting types
  """

  @primitive_types [
    :boolean,
    :integer,
    :string,
    :float,
    :decimal,
    :date,
    :time,
    :naive_datetime,
    :utc_datetime
  ]

  @typedoc "A type, primitive or custom."
  @type t :: primitive | custom

  @typedoc "Primitive types."
  @type primitive :: base | composite

  @typedoc "Custom types are represented by user-defined modules."
  @type custom :: atom

  @typep base ::
           :integer | :float | :boolean | :string | :decimal | :date | :time | :naive_datetime | :utc_datetime

  @typep composite :: {:array, t} | {:map, t}

  @doc """
  Returns the type name for the custom type.
  """
  @callback type :: t

  @doc """
  Casts the given input to the custom type.
  """
  @callback cast(value :: term) :: {:ok, casted_value :: term} | {:error, reason :: term()}

  def primitive_types, do: @primitive_types

  @doc """
  Casts the given input to the custom type.

  ## Basic types
      #{inspect(@primitive_types)}

  ## Example
      iex> cast(:integer, "1.0")
      {:ok, 1}
      iex> cast(:integer, "")
      {:error, :invalid}

      iex> cast(:string, "some string")
      {:ok, "some string"}
      iex> cast(:string, nil)
      {:ok, ""}

      iex> cast(:integer, "1")
      {:ok, 1}
      iex> cast(:integer, "1.0")
      {:ok, 1}

      iex> cast(:boolean, "1")
      {:ok, true}
      iex> cast(:boolean, "0")
      {:ok, false}

      iex> cast(:float, "1")
      {:ok, 1.0}
      iex> cast(:float, "1.0")
      {:ok, 1.0}

      iex> cast(:decimal, "1.001")
      {:ok, Decimal.new("1.001")}

      iex> cast(:date, "2024-01-15")
      {:ok, ~D[2024-01-15]}

      iex> cast(:time, "12:34:56")
      {:ok, ~T[12:34:56]}

      iex> cast(:naive_datetime, "2024-01-15T12:34:56")
      {:ok, ~N[2024-01-15 12:34:56]}

      iex> cast(:utc_datetime, "2024-01-15T12:34:56Z")
      {:ok, ~U[2024-01-15 12:34:56Z]}
  """
  @spec cast(t, term()) :: {:ok, term()} | {:error, term()}
  def cast(type, value) when type in @primitive_types do
    do_cast(type, value)
  end

  def cast(module, value) when is_atom(module) do
    if function_exported?(module, :cast, 1) do
      module.cast(value)
    else
      {:error, :invalid_type}
    end
  end

  @spec do_cast(type :: atom(), value :: term()) :: {:ok, value :: term()} | {:error, reason :: term()}
  defp do_cast(type, value)

  defp do_cast(:integer, value) when is_integer(value), do: {:ok, value}

  defp do_cast(:integer, value) when is_binary(value) do
    case Integer.parse(value) do
      {int, _tail} -> {:ok, int}
      _ -> {:error, :invalid}
    end
  end

  defp do_cast(:boolean, value) when is_boolean(value), do: {:ok, value}
  defp do_cast(:boolean, value) when value in ["true", "1"], do: {:ok, true}
  defp do_cast(:boolean, value) when value in ["false", "0"], do: {:ok, false}

  defp do_cast(:string, value) when is_binary(value), do: {:ok, value}

  defp do_cast(:string, value) do
    {:ok, to_string(value)}
  end

  defp do_cast(:float, value) when is_float(value), do: {:ok, value}

  defp do_cast(:float, value) when is_binary(value) do
    case Float.parse(value) do
      {float, ""} -> {:ok, float}
      _ -> {:error, :invalid}
    end
  end

  defp do_cast(:float, value) when is_integer(value), do: {:ok, value + 0.0}

  defp do_cast(:decimal, %Decimal{} = value), do: {:ok, value}

  defp do_cast(:decimal, term) when is_binary(term) do
    Decimal.cast(term)
  end

  defp do_cast(:decimal, term) when is_number(term) do
    {:ok, Decimal.from_float(term)}
  end

  defp do_cast(:date, %Date{} = value), do: {:ok, value}

  defp do_cast(:date, value) when is_binary(value) do
    case Date.from_iso8601(value) do
      {:ok, date} -> {:ok, date}
      {:error, reason} -> {:error, reason}
    end
  end

  defp do_cast(:time, %Time{} = value), do: {:ok, value}

  defp do_cast(:time, value) when is_binary(value) do
    case Time.from_iso8601(value) do
      {:ok, time} -> {:ok, time}
      {:error, reason} -> {:error, reason}
    end
  end

  defp do_cast(:naive_datetime, %NaiveDateTime{} = value), do: {:ok, value}

  defp do_cast(:naive_datetime, value) when is_binary(value) do
    case NaiveDateTime.from_iso8601(value) do
      {:ok, naive} -> {:ok, naive}
      {:error, reason} -> {:error, reason}
    end
  end

  defp do_cast(:utc_datetime, %DateTime{} = value), do: {:ok, value}

  defp do_cast(:utc_datetime, value) when is_binary(value) do
    case DateTime.from_iso8601(value) do
      {:ok, datetime, _offset} -> {:ok, datetime}
      {:error, reason} -> {:error, reason}
    end
  end

  defp do_cast(_type, _value), do: {:error, :invalid_type}
end
