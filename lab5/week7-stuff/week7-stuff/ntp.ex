# based on info at
# https://dev.to/l1x/matching-binary-patterns-11kh
defmodule Ntp do
  def get_info() do
    request = <<0::2, 4::3, 3::3, 0::376>>
    {:ok, socket} = :gen_udp.open(0, [:binary, {:active, false}])
    :gen_udp.send(socket, :"0.ca.pool.ntp.org", 123, request)
    {:ok, {_addr, _port, resp}} = :gen_udp.recv(socket, 0, 500)
    :gen_udp.close(socket)
    resp
  end

  def header(<<li::2, version::3, mode::3, stratum::8, poll::integer-signed-size(8), precision::size(8)-integer-signed, _rest::binary>>) do
    { li, version, mode, stratum, poll, precision }
  end
end

