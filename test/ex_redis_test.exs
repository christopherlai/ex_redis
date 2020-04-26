defmodule ExRedisTest do
  use ExUnit.Case
  doctest ExRedis

  test "greets the world" do
    assert ExRedis.hello() == :world
  end
end
