defmodule Nba.FakeHttp do
  @result %{
    "parameters" => [%{"PlayerID" => 111}, %{"LeagueID" => "00"}],
    "resource" => "commonplayerinfo",
    "resultSets" => [
      %{
        "headers" => [
          "PERSON_ID",
          "FIRST_NAME",
          "LAST_NAME",
          "DISPLAY_FIRST_LAST",
          "DISPLAY_LAST_COMMA_FIRST",
          "DISPLAY_FI_LAST",
          "BIRTHDATE",
          "SCHOOL",
          "COUNTRY",
          "LAST_AFFILIATION",
          "HEIGHT",
          "WEIGHT",
          "SEASON_EXP",
          "JERSEY",
          "POSITION",
          "ROSTERSTATUS",
          "TEAM_ID",
          "TEAM_NAME",
          "TEAM_ABBREVIATION",
          "TEAM_CODE",
          "TEAM_CITY",
          "PLAYERCODE",
          "FROM_YEAR",
          "TO_YEAR",
          "DLEAGUE_FLAG",
          "GAMES_PLAYED_FLAG",
          "DRAFT_YEAR",
          "DRAFT_ROUND",
          "DRAFT_NUMBER"
        ],
        "name" => "CommonPlayerInfo",
        "rowSet" => [
          [
            111,
            "LaPhonso",
            "Ellis",
            "LaPhonso Ellis",
            "Ellis, LaPhonso",
            "L. Ellis",
            "1970-05-05T00:00:00",
            "Notre Dame",
            "USA",
            "Notre Dame ''92/USA",
            "6-8",
            "240",
            11,
            "3",
            "Forward",
            "Active",
            1_610_612_743,
            "Nuggets",
            "DEN",
            "nuggets",
            "Denver",
            "laphonso_ellis",
            1992,
            2002,
            "N",
            "Y",
            "1992",
            "1",
            "5"
          ]
        ]
      },
      %{
        "headers" => [
          "PLAYER_ID",
          "PLAYER_NAME",
          "TimeFrame",
          "PTS",
          "AST",
          "REB",
          "ALL_STAR_APPEARANCES"
        ],
        "name" => "PlayerHeadlineStats",
        "rowSet" => [[111, "LaPhonso Ellis", "career", 11.9, 1.6, 6.5, 0]]
      },
      %{
        "headers" => ["SEASON_ID"],
        "name" => "AvailableSeasons",
        "rowSet" => [
          ["21992"],
          ["21993"],
          ["41993"],
          ["21994"],
          ["21995"],
          ["21996"],
          ["11997"],
          ["21997"],
          ["21998"],
          ["11999"],
          ["21999"],
          ["12000"],
          ["22000"],
          ["42000"],
          ["12001"],
          ["22001"],
          ["12002"],
          ["22002"]
        ]
      }
    ]
  }

  def get(url) do
    case URI.parse(url) do
      %URI{scheme: nil} -> :error
      %URI{host: nil} -> :error
      %URI{path: nil} -> :error
      _ -> @result
    end
  end
end
