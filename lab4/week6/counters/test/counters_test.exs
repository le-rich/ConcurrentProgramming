defmodule CountersTest do
  use ExUnit.Case
  doctest Counters

  test "greets the world" do
    assert Counters.hello() == :world
  end
end
