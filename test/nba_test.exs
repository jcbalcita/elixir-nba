defmodule NbaTest do
  use ExUnit.Case
  alias Nba.Parser
  doctest Nba

  test "creates functions for each endpoint" do
    Parser.endpoints_by_name()
    |> Map.keys()
    |> Enum.each(fn endpoint_name ->
      apply(Nba, :"#{endpoint_name}", [%{"dummy_key" => "dummy_value"}])
    end)
  end
end
