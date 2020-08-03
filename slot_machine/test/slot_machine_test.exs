defmodule SlotMachineTest do
  use ExUnit.Case
  doctest SlotMachine

  test "greets the world" do
    assert SlotMachine.hello() == :world
  end
end
