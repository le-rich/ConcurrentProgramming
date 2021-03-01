defmodule Counters.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Counters.Worker.start_link(arg)
      # {Counters.Worker, arg}
      {Registry, name: :registry, keys: :unique},
      Counters.WorkerSupervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    :ets.new(:counters, [:named_table, :public])
    opts = [strategy: :one_for_one, name: Counters.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
