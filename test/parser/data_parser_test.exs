defmodule Nba.Parser.DataTest do
  use ExUnit.Case
  doctest Nba.Parser.Data
  alias Nba.Parser

  Application.put_env(:nba, :http_data, Nba.FakeHttp.Data)

  test "parses full-year-schedule correctly" do
    # given
    response = Nba.FakeHttp.Data.get("https://data.nba.com/data/schedule")

    expected_keys =
      ~w(September October November December January February March April) |> MapSet.new()

    # when
    actual = Parser.Data.transform_schedule_response(response)

    # then
    month_keys = Map.keys(actual) |> MapSet.new()
    assert(expected_keys == month_keys)

    Enum.each(actual, fn {_, games_list} ->
      Enum.each(games_list, fn game ->
        assert(games_list |> is_list)
        Map.has_key?(game, "gid")
        Map.has_key?(game, "h")
        Map.has_key?(game, "v")
        Map.has_key?(game, "etm")
        Map.has_key?(game, "gdtutc")
      end)
    end)
  end
end
