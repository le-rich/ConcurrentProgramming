defmodule MydbTest do
  use ExUnit.Case
  doctest Mydb

  test "greets the world" do
    assert Mydb.hello() == :world
  end
end
