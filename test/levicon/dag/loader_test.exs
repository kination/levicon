defmodule Levicon.DAG.LoaderTest do
  use ExUnit.Case, async: true

  alias Levicon.DAG.Loader
  alias Levicon.Schema.DagSpec

  @fixture_path Path.join([__DIR__, "../../fixtures/valid_dag.yaml"])

  describe "load_string/1" do
    test "parses a valid DAG YAML string" do
      yaml = """
      id: simple_dag
      tasks:
        - name: hello
          type: shell
          command: echo hello
      """

      assert {:ok, %DagSpec{} = dag} = Loader.load_string(yaml)
      assert dag.id == "simple_dag"
      assert length(dag.tasks) == 1
      assert hd(dag.tasks).name == "hello"
    end

    test "parses tasks with cpu, memory, and volume_mounts" do
      yaml = """
      id: resource_dag
      tasks:
        - name: worker
          type: docker
          image: "my-image:latest"
          command: python run.py
          cpu: "500m"
          memory: "256Mi"
          volume_mounts:
            - /data/input
            - /data/output
      """

      assert {:ok, %DagSpec{} = dag} = Loader.load_string(yaml)
      task = hd(dag.tasks)
      assert task.cpu == "500m"
      assert task.memory == "256Mi"
      assert task.volume_mounts == ["/data/input", "/data/output"]
    end

    test "parses tasks with depends_on" do
      yaml = """
      id: dep_dag
      tasks:
        - name: first
          type: shell
          command: echo first
        - name: second
          type: shell
          command: echo second
          depends_on:
            - first
      """

      assert {:ok, %DagSpec{} = dag} = Loader.load_string(yaml)
      second = Enum.find(dag.tasks, &(&1.name == "second"))
      assert second.depends_on == ["first"]
    end

    test "returns error when dag id is missing" do
      yaml = """
      tasks:
        - name: hello
          type: shell
          command: echo hello
      """

      assert {:error, errors} = Loader.load_string(yaml)
      assert Keyword.has_key?(errors, :id)
    end

    test "returns error when task type is invalid" do
      yaml = """
      id: bad_dag
      tasks:
        - name: hello
          type: unknown
          command: echo hello
      """

      assert {:error, _errors} = Loader.load_string(yaml)
    end

    test "returns error on malformed YAML" do
      yaml = "id: [unclosed"

      assert {:error, _reason} = Loader.load_string(yaml)
    end
  end

  describe "load_file/1" do
    test "loads and parses the fixture YAML file" do
      assert {:ok, %DagSpec{} = dag} = Loader.load_file(@fixture_path)
      assert dag.id == "etl_pipeline"
      assert dag.schedule == "0 * * * *"
      assert length(dag.tasks) == 3
    end

    test "returns error for non-existent file" do
      assert {:error, :enoent} = Loader.load_file("/no/such/file.yaml")
    end
  end
end
