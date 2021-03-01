defmodule Mydb.WorkerSupervisor do 
  use DynamicSupervisor

  def start_link(dbname) do
    DynamicSupervisor.start_link(__MODULE__, nil, name: dbname)
  end

  def start_db(name) do
    DynamicSupervisor.start_child(__MODULE__, {Mydb.Worker, name})
  end

  def init(_) do
    DynamicSupervisor.init(stragety: :one_for_one)
  end

  def stop_db(dbname) do

  end
end
