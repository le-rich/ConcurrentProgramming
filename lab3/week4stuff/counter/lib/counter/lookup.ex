# incomplete implementation
defmodule Counter.Lookup do
  use GenServer

  def start() do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def get_pid(name) do
    GenServer.call(__MODULE__, {:get_pid, name})
  end

  def init(_arg) do
    {:ok, nil}
  end
  
  def handle_call({:get_pid, _name}, _from, state) do
    {:ok, pid} = Counter.Server.start
    {:reply, pid, state}
  end
end

