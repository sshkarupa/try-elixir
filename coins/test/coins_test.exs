defmodule CoinsTest do
  use ExUnit.Case
  doctest Coins

  test "greets the world" do
    assert Coins.hello() == :world
  end
end
