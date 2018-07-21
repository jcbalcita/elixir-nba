defmodule ElixirNbaTest do
  use ExUnit.Case
  alias ElixirNba.Parser
  doctest ElixirNba

  test "creates functions for each endpoint" do
    Parser.endpoints_by_name()
    |> Map.keys()
    |> Enum.each(fn endpoint_name ->
      apply(ElixirNba, :"#{endpoint_name}", [%{"dummy_key" => "dummy_value"}])
    end)
  end
end
