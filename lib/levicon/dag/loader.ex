defmodule Levicon.DAG.Loader do
  alias Levicon.Schema.DagSpec

  @doc """
  Loads a DAG definition from a YAML file path.
  Returns `{:ok, %DagSpec{}}` or `{:error, reason}`.
  """
  def load_file(path) do
    with {:ok, content} <- File.read(path) do
      load_string(content)
    end
  end

  @doc """
  Parses a YAML string into a `%DagSpec{}`.
  Returns `{:ok, %DagSpec{}}` or `{:error, reason}`.
  """
  def load_string(yaml_string) do
    with {:ok, raw} <- YamlElixir.read_from_string(yaml_string) do
      changeset = DagSpec.changeset(%DagSpec{}, raw)

      if changeset.valid? do
        {:ok, Ecto.Changeset.apply_changes(changeset)}
      else
        {:error, changeset.errors}
      end
    end
  end
end
