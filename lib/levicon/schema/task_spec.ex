defmodule Levicon.Schema.TaskSpec do
  use Ecto.Schema
  import Ecto.Changeset

  # embedded_schema: no DB table. Lives in memory after YAML parsing.
  embedded_schema do
    # Required fields
    field :name,    :string
    field :type,    :string
    field :command, :string   #("shell" or "docker")

    # Optional fields
    field :image,        :string,        default: nil
    field :retry,        :integer,       default: 0
    field :depends_on,   {:array, :string}, default: []
    field :cpu,          :string,        default: nil
    field :memory,       :string,        default: nil
    field :volume_mounts, {:array, :string}, default: []
  end

  @allowed_types ~w(shell docker)

  def changeset(task_spec, attrs) do
    task_spec
    |> cast(attrs, [:name, :type, :command, :image, :retry, :depends_on, :cpu, :memory, :volume_mounts])
    # 2. validate_required: enforce :name, :type, :command are present
    |> validate_required([:name, :type, :command])
    # 3. validate_inclusion: :type must be one of @allowed_types
    |> validate_inclusion(:type, @allowed_types)
    # 4. validate_number: :retry must be >= 0
    |> validate_number(:retry, greater_than_or_equal_to: 0)
    # 5. validate image conditionally:
    |> then(fn changeset ->
      if get_field(changeset, :type) == "docker" do
        validate_required(changeset, [:image])
      else
        changeset
      end
    end)
  end
end
