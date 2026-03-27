defmodule Levicon.Repo.Migrations.CreateRuns do
  use Ecto.Migration

  def change do
    create table(:runs, primary_key: false) do
      add :run_id,     :string,  primary_key: true
      add :dag_id,     :string,  null: false
      add :status,     :string,  null: false, default: "pending"
      add :params,     :map
      add :started_at, :utc_datetime
      add :ended_at,   :utc_datetime
      timestamps()
    end
  end
end
