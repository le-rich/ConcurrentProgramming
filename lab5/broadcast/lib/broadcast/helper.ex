defmodule Broadcast.Helper do
  def start(port \\ 3333) do
    {:ok, socket} = :gen_tcp.listen(port,
      [:binary, {:active, true}, {:packet, 0}, {:reuseaddr, true}])
    spawn(fn -> accept(socket) end)
  end

  def accept(socket) do
    {:ok, connected_socket} = :gen_tcp.accept(socket)
    Broadcast.Server.subscribe(spawn(fn -> accept(socket) end))
    loop(connected_socket)
  end

  def loop(socket) do
    receive do
      {:tcp, ^socket, bin} ->
        Broadcast.Server.broadcast(bin)
        loop(socket)
      {:message, message} ->
        :gen_tcp.send(socket, message) 
        loop(socket)
      {:tcp_closed, ^socket} ->
        :gen_tcp.close(socket)
    end
  end
end
