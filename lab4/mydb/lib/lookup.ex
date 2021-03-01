# COMP 4958 - Richard Le - SET 4V - A01080411
# Lab 3


defmodule Mydb.Lookup do
  use GenServer

  def start() do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def get_pid(name) do
    GenServer.call(__MODULE__, {:get_pid, name})
  end

  def init(_arg) do
    {:ok, %{}}
  end

  def handle_call({:get_pid, name}, _from, state) do
    if Map.has_key?(state, name) do
      {:reply, Map.get(state,name), state}
    else
      {_, pid} = Mydb.Server.start()
      {:reply, pid, Map.put(state, name, pid)}
    end 
  end
end
