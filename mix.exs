defmodule CastParams.MixProject do
  use Mix.Project

  @version "0.0.1"

  def project do
    [
      app: :cast_params,
      version: @version,
      elixir: ">= 1.5.0",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug, "~> 1.0"},

      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end
end
