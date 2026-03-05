import Config

if config_env() == :prod do
  config :levicon,
    port: String.to_integer(System.get_env("PORT", "4000")),
    api_key: System.fetch_env!("LEVICON_API_KEY"),
    aws_region: System.get_env("AWS_REGION", "us-east-1"),
    public_url: System.fetch_env!("LEVICON_PUBLIC_URL")

  config :levicon, Levicon.Repo,
    database: System.get_env("DATABASE_PATH", "/data/levicon.db")
end
