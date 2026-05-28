defmodule CastParams.MixProject do
  use Mix.Project

  @version "0.0.6"

  def project do
    [
      app: :cast_params,
      version: @version,
      elixir: "~> 1.14",
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
      {:plug, "~> 1.14"},
      {:decimal, "~> 2.0 or ~> 3.0"},

      # Test
      {:excoveralls, "~> 0.18", only: :test},
      {:stream_data, "~> 1.0", only: :test},
      {:phoenix, "~> 1.7", only: :test, runtime: false},

      # Dev
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false},
      {:mix_audit, "~> 2.1", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
    ]
  end

  # Settings for publishing in Hex package manager:
  defp package do
    %{
      maintainers: ["Anatolii Kovalchuk"],
      links: %{"GitHub" => "https://github.com/Kr00lIX/cast_params"},
      licenses: ["MIT"],
      files: ~w(lib LICENSE.md mix.exs README.md CHANGELOG.md)
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
