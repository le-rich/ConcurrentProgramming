# COMP 4958 - Richard Le - SET 4V - A01080411
# Lab 3

defmodule Mydb.Worker do
  use GenServer

  #client API
  def start_link(dbname) do 
    GenServer.start_link(__MODULE__, nil, name: dbname)
  end

  def store(dbname, key, value) do
    GenServer.cast(dbname, {:store, key, value})
  end

  def find(dbname, key) do
    GenServer.call(dbname, {:find, key})
  end

  def match(dbname, value) do
    GenServer.call(dbname, {:match, value})
  end

  #callbacks
  def init(_arg) do
    {:ok, Map.new()} 
  end 
    
  def handle_cast({:store, key, value}, map) do
    {:noreply, Map.put(map, key, value)}
  end
  
  def handle_call({:find, key}, _from, map) do
    if Map.has_key?(map, key) do
      val = Map.get(map, key) 
      {:reply, {:ok, val}, map}
    else
      {:reply, {:error, :not_found}, map}
    end
  end                    
  
  def handle_call({:match, value}, _from, map) do
    acc = Enum.filter(map, fn {_k, v} -> v == value end)
    acc = Enum.unzip(acc) |> elem(0)
    {:reply, acc, map}
  end
end
