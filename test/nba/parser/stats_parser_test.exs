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
      assert Map.get(params_by_name, p["name"]) == p
    end)
  end

  test "can read stats endpoints from endpoint json file" do
    # when
    endpoints = Parser.Stats.endpoints()
    endpoints_by_name = Parser.Stats.endpoints_by_name()

    # then
    assert Enum.count(endpoints) == 40

    Enum.each(endpoints, fn e ->
      assert Map.has_key?(e, "name") && Map.has_key?(e, "url") && Map.has_key?(e, "parameters")
      assert Map.get(endpoints_by_name, e["name"]) == e
    end)
  end

  test "there are example and default values for all parameters listed under the endpoints" do
    # given
    documented_params = Parser.Stats.params_by_name() |> Map.keys() |> MapSet.new()
    params_listed_under_endpoints = get_endpoint_params(Parser.Stats.endpoints())

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
          "headers" => ["player_name", "school", "draft_year"],
          "rowSet" => [
            ["John Carlo", "UCLA", "2009"],
            ["Kaylen", "UC Berkeley", "2012"]
          ]
        },
        %{
          "name" => "Headline",
          "headers" => ["player_name"],
          "rowSet" => [
            ["John Carlo"]
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
    assert result == {:ok, expected}
  end

  test "handles bad responses from api" do
    # given
    http_response = {:error, "what happen"}
    expected = {:error, "what happen"}

    # when
    result = Parser.Stats.transform_api_response(http_response)

    # then
    assert result == expected
  end

  test "handles results with column subgroups" do
    # given
    http_response = %{
      "resultSets" => %{
        "name" => "title",
        "headers" => [
          %{
            "columnsToSkip" => 2,
            "columnSpan" => 2,
            "columnNames" => ["First Group", "Second Group"]
          },
          %{
            "name" => "Base Columns",
            "columnNames" => ["Coolest Dude", "Power Level", "Repeat One", "Repeat Two", "Repeat One", "Repeat Two"]
          }
        ],
        "rowSet" => [
          ["John Carlo", "Over 9000", 1, 2, 3, 4],
          ["JC", "Over 8000", 5, 6, 7, 8]
        ]
      }
    }

    expected = %{
      "title" => [
        %{
          "Coolest Dude" => "John Carlo",
          "Power Level" => "Over 9000",
          "First Group" => %{
            "Repeat One" => 1,
            "Repeat Two" => 2
          },
          "Second Group" => %{
            "Repeat One" => 3,
            "Repeat Two" => 4
          }
        },
        %{
          "Coolest Dude" => "JC",
          "Power Level" => "Over 8000",
          "First Group" => %{
            "Repeat One" => 5,
            "Repeat Two" => 6
          },
          "Second Group" => %{
            "Repeat One" => 7,
            "Repeat Two" => 8
          }
        }
      ]
    }

    # when
    result = Nba.Parser.Stats.transform_api_response({:ok, http_response})

    # then
    assert result == {:ok, expected}
  end

  test "as failsafe, returns unmodified json response if it's a weird shape or parsing otherwise fails" do
    # given
    unexpected_but_valid_http_response = %{
      "resultStuff" => %{
        "name" => "Base Columns",
        "columnNames" => ["Coolest Dude", "Power Level", "Repeat One", "Repeat Two", "Repeat One", "Repeat Two"],
        "rowSet" => ["John Carlo", "Over 9000", 1, 2, 3, 4]
      }
    }

    # when
    result = Nba.Parser.Stats.transform_api_response({:ok, unexpected_but_valid_http_response})

    # then
    assert result == {:ok, unexpected_but_valid_http_response}
  end

  defp get_endpoint_params(endpoints) do
    params_loop(endpoints, MapSet.new())
  end

  defp params_loop([], result_set), do: result_set

  defp params_loop([endpoint | rest], result_set) do
    new_result_set =
      endpoint["parameters"]
      |> Enum.reduce(result_set, &MapSet.put(&2, &1))

    params_loop(rest, new_result_set)
  end
end
