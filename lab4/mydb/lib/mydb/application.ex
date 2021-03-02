defmodule Mydb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Mydb.Worker.start_link(arg)
      # {Mydb.Worker, arg}
      {Registry, name: :registry, keys: :unique},
      Mydb.WorkerSupervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    :ets.new(:dbs, [:named_table, :public])
    opts = [strategy: :one_for_one, name: Mydb.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
