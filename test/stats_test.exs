defmodule NbaTest.Stats do
  use ExUnit.Case
  alias Nba.Parser
  doctest Nba.Stats

  test "creates functions for each endpoint" do
    Parser.Stats.endpoints_by_name("stats")
    |> Map.keys()
    |> Enum.each(fn endpoint_name ->
      apply(Nba.Stats, :"#{endpoint_name}", [%{"dummy_key" => "dummy_value"}])
    end)
  end
end
