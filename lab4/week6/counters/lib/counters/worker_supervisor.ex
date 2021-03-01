defmodule Counters.WorkerSupervisor do
  use DynamicSupervisor

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def start_counter(name) do
    DynamicSupervisor.start_child(__MODULE__, {Counters.Worker, name})
  end

  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

end
