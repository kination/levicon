defmodule Levicon.Schema.Run do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:run_id, :string, autogenerate: false}

  schema "runs" do
    field :dag_id,     :string
    field :status,     Ecto.Enum,
                       values: [:pending, :running, :done, :failed, :cancelled],
                       default: :pending
    field :params,     :map
    field :started_at, :utc_datetime
    field :ended_at,   :utc_datetime
    timestamps()
  end

  def changeset(run, attrs) do
    run
    |> cast(attrs, [:run_id, :dag_id, :status, :params, :started_at, :ended_at])
    |> validate_required([:run_id, :dag_id])
  end

  def update_status_changeset(run, attrs) do
    run
    |> cast(attrs, [:status, :started_at, :ended_at])
    |> validate_required([:status])
  end
end
