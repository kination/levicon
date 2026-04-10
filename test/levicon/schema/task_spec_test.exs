defmodule Levicon.Schema.TaskSpecTest do
  use ExUnit.Case, async: true

  alias Levicon.Schema.TaskSpec

  defp valid_attrs do
    %{
      name: "task_1",
      type: "shell",
      command: "echo hello",
      retry: 0,
      depends_on: []
    }
  end

  describe "changeset/2" do
    test "valid with required fields" do
      changeset = TaskSpec.changeset(%TaskSpec{}, valid_attrs())
      assert changeset.valid?
    end

    test "invalid without name" do
      changeset = TaskSpec.changeset(%TaskSpec{}, Map.delete(valid_attrs(), :name))
      assert %{name: [_ | _]} = errors_on(changeset)
    end

    test "invalid without command" do
      changeset = TaskSpec.changeset(%TaskSpec{}, Map.delete(valid_attrs(), :command))
      assert %{command: [_ | _]} = errors_on(changeset)
    end

    test "invalid with unknown type" do
      changeset = TaskSpec.changeset(%TaskSpec{}, Map.put(valid_attrs(), :type, "eks"))
      assert %{type: [_ | _]} = errors_on(changeset)
    end

    test "invalid when retry is negative" do
      changeset = TaskSpec.changeset(%TaskSpec{}, Map.put(valid_attrs(), :retry, -1))
      assert %{retry: [_ | _]} = errors_on(changeset)
    end

    test "invalid when type is docker and image is missing" do
      attrs = valid_attrs() |> Map.put(:type, "docker")
      changeset = TaskSpec.changeset(%TaskSpec{}, attrs)
      assert %{image: [_ | _]} = errors_on(changeset)
    end

    test "valid when type is docker and image is present" do
      attrs = valid_attrs() |> Map.merge(%{type: "docker", image: "my-image:latest"})
      changeset = TaskSpec.changeset(%TaskSpec{}, attrs)
      assert changeset.valid?
    end

    test "valid when type is shell and image is absent" do
      changeset = TaskSpec.changeset(%TaskSpec{}, valid_attrs())
      assert changeset.valid?
    end
  end

  defp errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
  end
end
