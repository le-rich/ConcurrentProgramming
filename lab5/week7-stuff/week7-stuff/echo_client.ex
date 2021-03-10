defmodule EchoClient do
  def client(host, port, msg) do
    {:ok, socket} = :gen_tcp.connect(host, port,
      [:binary, {:active, false}, {:packet, 0}])

    :ok = :gen_tcp.send(socket, msg)
    {:ok, bin} = :gen_tcp.recv(socket, 0)
    :ok = :gen_tcp.close(socket)
    bin
  end
end
