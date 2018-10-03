defmodule Nba.Parser.PlayerTest do
  use ExUnit.Case
  doctest Nba.Parser.Player
  alias Nba.Parser

test "can read players from players json file" do
    # when
    players = Parser.Player.players()
    players_by_id = Parser.Player.players_by_id()

    # then
    assert Enum.count(players) == 576

    assert Enum.each(players, fn p ->
             assert Map.has_key?(p, "player_id") && Map.has_key?(p, "first_name") &&
                      Map.has_key?(p, "last_name") && Map.has_key?(p, "team_id")
           end)

    Enum.each(players, fn p ->
      id = p["player_id"]
      assert Map.has_key?(players_by_id, id)
      assert players_by_id[id] == p
    end)
  end
end