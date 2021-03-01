defmodule Weather.Server do
  use GenServer

  # client API
  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end 

  def data_for(location) do
    GenServer.call(__MODULE__, {:location, location})
  end 

  def data_for(city, country) do
    GenServer.call(__MODULE__, {:location, city, country})
  end 

  def stop() do
    GenServer.stop(__MODULE__, :normal)
  end 

  # callbacks
  def init(_arg) do
    {:ok, nil}
  end 

  def handle_call({:location, key}, _from, state) do
    {:reply, Weather.Core.locationAPIQuery(key), state}
  end 

  def handle_call({:location, city, country}, _from, state) do
    {:reply, Weather.Core.cityCountryAPIQuery(city, country), state}
  end 

end

