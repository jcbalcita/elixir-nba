defmodule Nba.StatsTest do
  use ExUnit.Case
  alias Nba.Parser
  doctest Nba.Stats

  Application.put_env(:nba, :http_stats, Nba.FakeHttp.Stats)

  test "creates functions for each endpoint" do

    Parser.Stats.endpoints_by_name()
    |> Map.keys()
    |> Enum.each(fn endpoint_name ->
      apply(Nba.Stats, :"#{endpoint_name}", [%{"dummy_key" => "dummy_value"}])
    end)
  end
end
