defmodule CastParams.MixProject do
  use Mix.Project

  @version "0.0.5"

  def project do
    [
      app: :cast_params,
      version: @version,
      elixir: ">= 1.5.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      description: "CastParams creates plug for casting params to defined types.",
      package: package(),
      aliases: aliases(),
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
      {:decimal, "~> 2.0"},

      # Test
      {:excoveralls, "~> 0.8", only: :test},
      {:stream_data, "~> 0.1", only: :test},
      {:phoenix, "~> 1.3", only: :test, runtime: false},

      # Dev
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.17", only: :dev, runtime: false},
      {:mix_audit, "~> 2.0", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
    ]
  end

  # Settings for publishing in Hex package manager:
  defp package do
    %{
      package: "cast_params",
      contributors: ["Kr00lIX"],
      maintainers: ["Anatolii Kovalchuk"],
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

  # Aliases are shortcuts or tasks specific to the current project.
  defp aliases do
    [
      validate: [
        "compile --warnings-as-errors",
        "credo",
        "format --check-formatted",
        "test",
        "deps.audit",
        "dialyzer"
      ]
    ]
  end

  def cli do
    [
      preferred_envs: [
        validate: :test
      ]
    ]
  end
end
