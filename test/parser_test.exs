defmodule Nba.ParserTest do
  use ExUnit.Case
  doctest Nba.Parser
  alias Nba.Parser

  test "can read parameters from endpoint json file" do
    # when
    parameters = Parser.Endpoint.parameters()
    params_by_name = Parser.Endpoint.params_by_name()

    # then
    assert Enum.count(parameters) == 76

    Enum.each(parameters, fn p ->
      assert Map.has_key?(p, "name") && Map.has_key?(p, "default") && Map.has_key?(p, "values")
    end)

    Enum.each(parameters, fn p ->
      assert Map.has_key?(params_by_name, p["name"])
      assert Map.get(params_by_name, p["name"]) == p
    end)
  end

  test "can read stats endpoints from endpoint json file" do
    # when
    parameters = Parser.Endpoint.parameters()
    endpoints = Parser.Endpoint.endpoints("stats")
    params_by_name = Parser.Endpoint.params_by_name()
    endpoints_by_name = Parser.Endpoint.endpoints_by_name("stats")

    # then
    assert Enum.count(parameters) == 76
    assert Enum.count(endpoints) == 32

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

  test "can read headers from endpoint json file" do
    # when
    headers = Parser.Endpoint.headers()

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

  test "can read players from players json file" do
    # when
    players = Parser.Player.players()
    players_by_id = Parser.Player.players_by_id()

    # then
    assert Enum.count(players) == 523

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

  test "correctly parses json from api response" do
    # given
    json_response = %{
      "resource" => "commonplayerinfo",
      "resultSets" => [
        %{
          "name" => "CommonPlayerInfo",
          "headers" => [
            "player_name",
            "school",
            "draft_year"
          ],
          "rowSet" => [
            [
              "John Carlo",
              "UCLA",
              "2009"
            ],
            [
              "Kaylen",
              "UC Berkeley",
              "2012"
            ]
          ]
        },
        %{
          "name" => "Headline",
          "headers" => [
            "player_name"
          ],
          "rowSet" => [
            [
              "John Carlo"
            ]
          ]
        }
      ]
    }

    expected = %{
      "CommonPlayerInfo" => [
        %{
          "player_name" => "John Carlo",
          "school" => "UCLA",
          "draft_year" => "2009"
        },
        %{
          "player_name" => "Kaylen",
          "school" => "UC Berkeley",
          "draft_year" => "2012"
        }
      ],
      "Headline" => [
        %{
          "player_name" => "John Carlo"
        }
      ]
    }

    # when
    result = Parser.transform_api_response({:ok, json_response})

    # then
    assert result == expected
  end

  test "handles bad responses from api" do
    # given
    json_response = %{"error" => "what happen"}
    expected = %{}

    # when
    result = Parser.transform_api_response({:error, json_response})

    # then
    assert result == expected
  end
end
