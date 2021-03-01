defmodule Counters.Worker do
  use GenServer

  # client API
  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: via(name))
  end

  def inc(name, amt \\ 1) do
    GenServer.cast(via(name), {:inc, amt})
  end

  def dec(name, amt \\ 1) do
    GenServer.cast(via(name), {:dec, amt})
  end

  def value(name) do
    GenServer.call(via(name), :value)
  end

  defp via(name) do
    {:via, Registry, {:registry, {__MODULE__, name}}}
  end

  # callbacks
  @impl true
  def init(name) do
    case :ets.lookup(:counters, name) do
      [] -> {:ok, {name, 0}}
      [{_, x}] -> {:ok, {name, x}}
    end
  end

  @impl true
  def handle_cast({:inc, amt}, {name, value}) do
    {:noreply, {name, value + amt}}
  end

  @impl true
  def handle_cast({:dec, amt}, {name, value}) do
    {:noreply, {name, value - amt}}
  end

  @impl true
  def handle_call(:value, _from, {_name, value} = state) do
    {:reply, value, state}
  end

  @impl true
  def handle_info(:reset, _state) do
    {:noreply, 0}
  end

  @impl true
  def terminate(_reason, {name, value}) do
    :ets.insert(:counters, {name, value})
  end
end

