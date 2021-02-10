defmodule Counter.Server do
  use GenServer

  # client API
  def start() do
    GenServer.start(__MODULE__, nil)
  end

  def inc(pid) do
    GenServer.cast(pid, :inc)
  end

  def dec(pid) do
    GenServer.cast(pid, :dec)
  end

  def value(pid) do
    GenServer.call(pid, :value)
  end

  # callbacks
  def init(_arg) do
    {:ok, 0}
  end

  def handle_cast(:inc, state) do
    {:noreply, state + 1}
  end

  def handle_cast(:dec, state) do
    {:noreply, state - 1}
  end

  def handle_call(:value, _from, state) do
    {:reply, state, state}
  end

  def handle_info(:reset, state) do
    {:noreply, 0}
  end
end

