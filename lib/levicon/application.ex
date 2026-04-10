defmodule Levicon.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Process registry — swap to Horde.Registry for clustering later
      {Registry, keys: :unique, name: Levicon.Registry},

      # # ETS-backed state snapshots
      # Levicon.Status.Store,

      # Task process supervisor
      # {DynamicSupervisor, name: Levicon.DAG.Supervisor, strategy: :one_for_one},

      # HTTP client pool
      {Finch, name: Levicon.Finch},

      # # Worker dispatcher
      # Levicon.Worker.Dispatcher,

      # # DAG orchestration engine
      # Levicon.DAG.Engine,

      # Ecto repo
      Levicon.Repo,

      # # Cron scheduler
      # Levicon.Scheduler,

      # # HTTP server (REST API + webhooks)
      # {Bandit, plug: Levicon.Web.Router, port: Application.get_env(:levicon, :port, 4000)},

      # # Prometheus metrics
      # {TelemetryMetricsPrometheus, metrics: Levicon.Telemetry.metrics()}
    ]

    # rest_for_one: if DAG.Engine dies, everything after it restarts too
    opts = [strategy: :rest_for_one, name: Levicon.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
