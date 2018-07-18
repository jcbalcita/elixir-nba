defmodule ParserTest do
  use ExUnit.Case
  doctest ElixirNba.Parser
  alias ElixirNba.Parser

  test "can read json file" do
    assert Enum.count(Parser.parameters()) == 77
    assert Enum.count(Parser.endpoints()) == 32
  end
end