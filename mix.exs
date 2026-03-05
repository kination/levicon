defmodule Levicon.MixProject do
  use Mix.Project

  def project do
    [
      app: :levicon,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),
      escript: [main_module: LeviconCLI]
    ]
  end

  def application do
    [
      extra_applications: [:logger, :inets, :crypto],
      mod: {Levicon.Application, []}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      # HTTP server
      {:bandit, "~> 1.5"},
      {:plug, "~> 1.16"},

      # HTTP client
      {:finch, "~> 0.19"},

      # YAML parsing
      {:yaml_elixir, "~> 2.9"},

      # Persistence
      {:ecto_sql, "~> 3.12"},
      {:ecto_sqlite3, "~> 0.17"},

      # Cron scheduler
      {:quantum, "~> 3.5"},
      {:timex, "~> 3.7"},

      # JSON
      {:jason, "~> 1.4"},

      # Metrics
      {:telemetry, "~> 1.2"},
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_metrics_prometheus, "~> 1.1"},

      # Structured logging
      {:logger_json, "~> 6.1"},

      # Test
      {:mox, "~> 1.2", only: :test}
    ]
  end
end
