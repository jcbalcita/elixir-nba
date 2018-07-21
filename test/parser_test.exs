defmodule ParserTest do
  use ExUnit.Case
  doctest ElixirNba.Parser
  alias ElixirNba.Parser

  test "can read parameters and endpoints from json file" do
    # when
    parameters = Parser.parameters()
    endpoints = Parser.endpoints()
    params_by_name = Parser.params_by_name()
    endpoints_by_name = Parser.endpoints_by_name()

    # then
    Enum.each(endpoints, fn p ->
      assert Map.has_key?(p, "name") && Map.has_key?(p, "url") && Map.has_key?(p, "parameters")
    end)

    Enum.each(parameters, fn p ->
      assert Map.has_key?(p, "name") && Map.has_key?(p, "default") && Map.has_key?(p, "values")
    end)

    Enum.each(parameters, fn p ->
      assert Map.has_key?(params_by_name, p["name"])
      assert Map.get(params_by_name, p["name"]) == p
    end)

    Enum.each(endpoints, fn e ->
      assert Map.has_key?(endpoints_by_name, e["name"])
      assert Map.get(endpoints_by_name, e["name"]) == e
    end)
  end

  test "creates headers map from json file" do
    # when
    headers = Parser.headers()

    # then
    assert headers["Referer"] == "http://stats.nba.com"
    assert headers["Referrer"] == "http://stats.nba.com"
    assert headers["Origin"] == "http://stats.nba.com"
    assert headers["Accept-Encoding"] == "gzip, deflate"
    assert headers["Accept-Language"] == "en-US"
    assert headers["Accept"] == "*/*"
    assert headers["Connection"] == "keep-alive"
    assert headers["Cache-Control"] == "no-cache"

    assert headers["User-Agent"] ==
             "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:61.0) Gecko/20100101 Firefox/61.0"
  end

  test "creates parameter_name -> default_value map from json file" do
    # given
    expected = %{
      "LeagueID" => "00",
      "SeasonType" => "Regular Season",
      "PlayerID" => "1"
    }

    player_info_endpoint =
      Parser.endpoints()
      |> Enum.find(fn e -> e["name"] == "player_info" end)

    valid_player_info_parameters = player_info_endpoint["parameters"]

    # when
    result = Parser.defaults_for_these_parameters(valid_player_info_parameters)

    # then
    assert result == expected
  end
end
