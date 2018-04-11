defmodule CastParams.Config do
  @moduledoc """
  Configure schema definition 
  ## Options
  *`nulify*` - Set default param to nil. `true` - by default.
  """
  alias CastParams.Config

  @type t :: %Config{
    nulify: boolean
  }

  defstruct [:nulify]

  @doc """
  Configure Schema
  
  ## Examples
      iex> init(nulify: false)
      %CastParams.Config{nulify: false}
  """
  def init(options) when is_list(options) do
    %Config{
      nulify: get_option(options, :nulify)
    }
  end

  defp get_option(options, key) do
    Keyword.get(
      options,
      key,
      Application.get_env(:cast_params, key)
    )
  end
end