# this version uses active sockets
defmodule EchoServer do
  def start(port \\ 3333) do
    {:ok, socket} = :gen_tcp.listen(port,
      [:binary, {:active, true}, {:packet, 0}, {:reuseaddr, true}])
    spawn(fn -> accept(socket) end)
  end

  def accept(socket) do
    {:ok, connected_socket} = :gen_tcp.accept(socket)
    spawn(fn -> accept(socket) end)
    loop(connected_socket)
  end
  
  def loop(socket) do
    receive do
      {:tcp, ^socket, bin} ->
        :gen_tcp.send(socket, bin)
        loop(socket)
      {:tcp_closed, ^socket} ->
        :gen_tcp.close(socket)
    end
  end
end



