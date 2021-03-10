# COMP 495 Lab 5
# SET 4V - A01080411 - Richard Le

defmodule Broadcast.Server do
  use GenServer

  # CLIENT API
  def start() do
    GenServer.start_link(__MODULE__, nil, name: {:global, __MODULE__})
  end

  def subscribe(pid) do
    GenServer.cast({:global, __MODULE__}, {:subscribe, pid}) 
  end

  def unsubscribe(pid) do
    GenServer.cast({:global, __MODULE__}, {:unsubscribe, pid})
  end

  def broadcast(message) do
    GenServer.cast({:global, __MODULE__}, {:broadcast, message})
  end

  # CALLBACKS
  def init(_arg) do
    {:ok, []}
  end

  def handle_cast({:subscribe, pid}, subLst) do
    {:noreply, subLst ++ [pid]}
  end

  def handle_cast({:unsubscribe, pid}, subLst) do
    {:noreply, List.delete(subLst, pid)} 
  end

  def handle_cast({:broadcast, message}, subLst) do
    Enum.each(subLst, fn x -> send(x, {:message, message}) end)
    {:noreply, subLst}
  end
end
