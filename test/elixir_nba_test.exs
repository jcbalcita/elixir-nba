defmodule ElixirNbaTest do
  use ExUnit.Case
  doctest ElixirNba

  test "creates functions for each endpoint" do
    assert ElixirNba.player_profile(%{"PlayerID" => "0"}) == "http://stats.nba.com/stats/playerprofilev2"
    assert ElixirNba.scoreboard(%{}) == "http://stats.nba.com/stats/scoreboard"
  end
end
