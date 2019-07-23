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

  # test "can be configured to read a specific players json file" do
  #   # when
  #   players = Parser.Player.players()

  #   # then
  #   assert Enum.count(players) == 2
  #   IO.inspect(players)

  #   player_one = Enum.at(players, 0)
  #   player_two = Enum.at(players, 1)
  #   assert player_one["player_id"] == 10
  #   assert player_two["player_id"] == 11
  # end
end
