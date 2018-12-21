defmodule Nba.DataTest do
  use ExUnit.Case
  doctest Nba.Data

  test "find_player/1 finds players by first name" do
    # when
    result = Nba.Data.find_player(first_name: "kevin")
    # then
    assert Enum.any?(result, fn r -> r["first_name"] == "Kevon" end)
  end

  test "find_player/1 finds players by last name" do
    # when
    result = Nba.Data.find_player(last_name: "ingr")
    # then
    assert List.first(result)["last_name"] == "Ingram"
  end

  test "find_player/1 finds players by full name" do
    # when
    [first, second] = Nba.Data.find_player(full_name: "Steph Curry")
    # then
    assert first["first_name"] == "Stephen"
    assert second["first_name"] == "Seth"
  end

  test "find_player/1 can take in a string" do
    # when
    [first, second] = Nba.Data.find_player("J Holiday")
    # then
    assert first["first_name"] == "Jrue"
    assert second["first_name"] == "Justin"
  end

  test "find_player!/1 returns a single result" do
    # given
    expected = %{
      "first_name" => "Jrue",
      "last_name" => "Holiday",
      "player_id" => 201_950,
      "team_id" => 1_610_612_740
    }

    # when
    result = Nba.Data.find_player!("J Holiday")
    # then
    assert result == expected
  end
end
