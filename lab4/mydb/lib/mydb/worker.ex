# COMP 4958 - Richard Le - SET 4V - A01080411
# Lab 4 

defmodule Mydb.Worker do
  use GenServer

  #client API
  def start_link(dbname) do 
    GenServer.start_link(__MODULE__, dbname, name: via(dbname))
  end

  def store(dbname, key, value) do
    GenServer.cast(via(dbname), {:store, key, value})
  end

  def find(dbname, key) do
    GenServer.call(via(dbname), {:find, key})
  end

  def match(dbname, value) do
    GenServer.call(via(dbname), {:match, value})
  end
  
  defp via(name) do
    {:via, Registry, {:registry, {__MODULE__, name}}}
  end

  #callbacks
  def init(name) do
    case :ets.lookup(:dbs, name) do
      [] -> {:ok, {name, Map.new()}}
      [{_, x}] -> {:ok, {name, x}}
    end
  end 
    
  def handle_cast({:store, key, value}, {name, map}) do
    {:noreply, {name, Map.put(map, key, value)}}
  end
  
  def handle_call({:find, key}, _from, {name, map}) do
    if Map.has_key?(map, key) do
      val = Map.get(map, key) 
      {:reply, {:ok, val}, {name, map}}
    else
      {:reply, {:error, :not_found}, {name, map}}
    end
  end                    
  
  def handle_call({:match, value}, _from, {name, map}) do
    acc = Enum.filter(map, fn {_k, v} -> v == value end)
    acc = Enum.unzip(acc) |> elem(0)
    {:reply, acc, {name, map}}
  end
end
