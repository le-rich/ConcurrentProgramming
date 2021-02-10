defmodule Server do
  def start(mod) do
    spawn(fn -> loop(mod, mod.init()) end)
  end

  def call(pid, msg) do
    send(pid, {:call, self(), msg})
    receive do
      {^pid, reply} -> reply
    end
  end

  def cast(pid, msg) do
    send(pid, {:cast, msg})
  end

  def swap_code(pid, newmod) do
    send(pid, {:swap_code, self(), newmod})
    receive do
      {^pid, reply} -> reply
    end
  end

  def loop(mod, state) do
    receive do
      {:call, from, msg} ->
        {reply, newstate} = mod.handle_call(msg, state)
        send(from, {self(), reply})
        loop(mod, newstate)
      {:cast, msg} ->
        newstate = mod.handle_cast(msg, state)
        loop(mod, newstate)
      {:swap_code, from, newmod} ->
        send(from, {self(), :ok})
        loop(newmod, state)
    end
  end
end

defmodule Counter do
  def init() do
    0
  end

  def handle_cast(:inc, state) do
    state + 1
  end

  def handle_cast(:dec, state) do
    state - 1
  end

  def handle_call(:value, state) do
    {state, state}
  end
end

defmodule Counter2 do
  def init() do
    0
  end

  def handle_cast(:inc, state) do
    state + 1
  end

  def handle_cast(:dec, state) do
    state - 1
  end

  def handle_cast({:step, n}, state) do
    state + n
  end

  def handle_call(:value, state) do
    {state, state}
  end
end
