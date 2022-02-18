defmodule MyPlugAppTest do
  use ExUnit.Case
  doctest MyPlugApp

  test "greets the world" do
    assert MyPlugApp.hello() == :world
  end
end
