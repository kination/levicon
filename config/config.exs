import Config

config :levicon,
  port: 4000,
  api_key: System.get_env("LEVICON_API_KEY", "dev-key"),
  aws_region: System.get_env("AWS_REGION", "us-east-1"),
  public_url: System.get_env("LEVICON_PUBLIC_URL", "http://localhost:4000")

config :levicon, Levicon.Repo,
  database: "levicon_dev.db"

config :levicon, ecto_repos: [Levicon.Repo]

config :levicon, Levicon.Scheduler,
  jobs: []
