defmodule Nba.Parser.StatsTest do
  use ExUnit.Case
  doctest Nba.Parser.Stats
  alias Nba.Parser

  defp get_params_helper() do
    params_loop(Parser.Stats.endpoints(), MapSet.new())
  end

  defp params_loop([], result_set), do: result_set

  defp params_loop([endpoint | rest], result_set) do
    new_result_set =
      endpoint["parameters"]
      |> Enum.reduce(result_set, &MapSet.put(&2, &1))

    params_loop(rest, new_result_set)
  end

  test "can read parameters from endpoint json file" do
    # when
    parameters = Parser.Stats.parameters()
    params_by_name = Parser.Stats.params_by_name()

    # then
    assert Enum.count(parameters) == 77

    Enum.each(parameters, fn p ->
      assert Map.has_key?(p, "name") && Map.has_key?(p, "default") && Map.has_key?(p, "values")
      assert Map.get(params_by_name, p["name"]) == p
    end)
  end

  test "can read stats endpoints from endpoint json file" do
    # when
    endpoints = Parser.Stats.endpoints()
    endpoints_by_name = Parser.Stats.endpoints_by_name()

    # then
    assert Enum.count(endpoints) == 34

    Enum.each(endpoints, fn e ->
      assert Map.has_key?(e, "name") && Map.has_key?(e, "url") && Map.has_key?(e, "parameters")
      assert Map.get(endpoints_by_name, e["name"]) == e
    end)
  end

  test "there are example and default values for all parameters listed under the endpoints" do
    # given
    documented_params = Parser.Stats.params_by_name() |> Map.keys() |> MapSet.new()
    params_listed_under_endpoints = get_params_helper()

    # when
    difference = MapSet.difference(params_listed_under_endpoints, documented_params)

    # then
    assert MapSet.size(difference) == 0
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
    http_response = {:error, "what happen"}
    expected = %{error: "what happen"}

    # when
    result = Parser.Stats.transform_api_response(http_response)

    # then
    assert result == expected
  end
end
