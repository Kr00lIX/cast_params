defmodule CastParams.MixProject do
  use Mix.Project

  @version "0.0.2"

  def project do
    [
      app: :cast_params,
      version: @version,
      elixir: ">= 1.4.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test, "coveralls.travis": :test],
      description: "CastParams creates plug for casting params to defined types.",
      package: package(),
      name: "CastParams",
      docs: docs(),
      elixirc_paths: elixirc_paths(Mix.env())
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
      {:decimal, "~> 1.2"},
      {:excoveralls, "~> 0.8", only: :test},
      {:phoenix, "~> 1.3", only: :test, runtime: false},
      {:dialyxir, "~> 0.5", only: :dev, runtime: false},
      {:ex_doc, "~> 0.17", only: :dev, runtime: false}
    ]
  end

  # Settings for publishing in Hex package manager:
  defp package do
    %{
      package: "cast_params",
      contributors: ["Kr00lIX"],
      maintainers: ["Anatoliy Kovalchuk"],
      links: %{github: "https://github.com/Kr00lIX/cast_params"},
      licenses: ["LICENSE.md"],
      files: ~w(lib LICENSE.md mix.exs README.md)
    }
  end

  defp docs do
    [
      main: "CastParams",
      source_ref: "v#{@version}",
      extras: ["README.md"],
      source_url: "https://github.com/Kr00lIX/cast_params"
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
