defmodule CastParams.Config do
  alias CastParams.Param

  def configure(options) do
    Enum.map(options, &config_param/1)
  end

  defp config_param({name, raw_type}) do
    Param.parse(name, raw_type)
  end

end