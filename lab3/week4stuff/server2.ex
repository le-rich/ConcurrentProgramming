defmodule Server2 do
  def start() do
    spawn(fn -> wait() end)
  end

  def become(pid, f) do
    send(pid, {:become, f})
  end

  def wait() do
    receive do
      {:become, f} -> f.()
    end
  end

  def call(pid, msg) do
    send(pid, {self(), msg})
    receive do
      {^pid, reply} -> reply
    end
  end
end

defmodule FacServer do
  def loop() do
    receive do
      {from, {:fac, n}} ->
        send(from, {self(), fac(n)})
        loop()
      {:become, f} ->
        f.()
    end
  end

  def fac(n) when n <= 0, do: 1

  def fac(n), do: n * fac(n-1)
end

defmodule SquareServer do
  def loop() do
    receive do
      {from, {:square, n}} ->
        send(from, {self(), n * n})
        loop()
      {:become, f} ->
        f.()
    end
  end
end
