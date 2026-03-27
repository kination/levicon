defmodule Levicon.Schema.DagSpec do
  use Ecto.Schema
  import Ecto.Changeset

  alias Levicon.Schema.TaskSpec

  @primary_key false
  embedded_schema do
    field :id,       :string
    field :schedule, :string, default: nil

    embeds_many :tasks, TaskSpec
  end

  def changeset(dag_spec, attrs) do
    dag_spec
    |> cast(attrs, [:id, :schedule])
    |> validate_required([:id])
    |> cast_embed(:tasks, required: true)
  end
end
