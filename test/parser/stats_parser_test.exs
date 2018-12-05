defmodule Nba.Parser.StatsTest do
  use ExUnit.Case
  doctest Nba.Parser.Stats
  alias Nba.Parser

  test "can read parameters from endpoint json file" do
    # when
    parameters = Parser.Stats.parameters()
    params_by_name = Parser.Stats.params_by_name()

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
    parameters = Parser.Stats.parameters()
    endpoints = Parser.Stats.endpoints()
    params_by_name = Parser.Stats.params_by_name()
    endpoints_by_name = Parser.Stats.endpoints_by_name()

    # then
    assert Enum.count(parameters) == 76
    assert Enum.count(endpoints) == 33

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
    result = Parser.Stats.transform_api_response({:ok, json_response})

    # then
    assert result == expected
  end

  test "handles bad responses from api" do
    # given
    json_response = %{"error" => "what happen"}
    expected = %{}

    # when
    result = Parser.Stats.transform_api_response({:error, json_response})

    # then
    assert result == expected
  end
end
