import Config

config :levicon, Levicon.Repo,
  database: ":memory:",
  pool: Ecto.Adapters.SQL.Sandbox
