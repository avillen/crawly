defmodule Crawly.EngineSup do
  use DynamicSupervisor

  def start_link do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_spider(spider_name) do
    case Code.ensure_loaded?(spider_name) do
      true ->
        # Given spider module exists in the namespace, we can proceed
        {:ok, _sup_pid} =
          DynamicSupervisor.start_child(
            __MODULE__,
            {Crawly.ManagerSup, spider_name}
          )

      false ->
        {:error, "Spider: #{inspect(spider_name)} was not defined"}
    end
  end

  def stop_spider(spider_name) do
    {:ignore, :not_implemented}
  end
end
