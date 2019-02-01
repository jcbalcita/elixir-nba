defmodule Nba.Data do
  alias Nba.Parser

  @schedule_url "https://data.nba.com/data/10s/v2015/json/mobile_teams/nba/2018/league/00_full_schedule_week.json"
  @minimum_similarity 0.83

  defp http, do: Application.get_env(:nba, :http, Nba.Http)

  @doc """
  Returns a list of players sorted by best match.

  You can pass in a single key-value pair for first name, last name,
  or full name.

      Nba.Data.find_player(first_name: "brandn")
      Nba.Data.find_player(last_name: "ingrm")
      Nba.Data.find_player(full_name: "brandn ingram")

  You may also pass in a string as an argument.

      iex> Nba.Data.find_player("J Holiday")
      [%{
        "first_name" => "Jrue",
        "last_name" => "Holiday",
        "player_id" => 201950,
        "team_id" => 1610612740
      },
      %{
        "first_name" => "Justin",
        "last_name" => "Holiday",
        "player_id" => 203200,
        "team_id" => 1610612741
      }]
  """
  @spec find_player(list(tuple) | String.t) :: list(map)
  def find_player(first_name: first_name) do
    Parser.Player.players()
    |> Enum.filter(fn p ->
      String.jaro_distance(String.downcase(p["first_name"]), String.downcase(first_name)) >
        @minimum_similarity
    end)
    |> Enum.sort_by(
      fn p ->
        String.jaro_distance(String.downcase(p["first_name"]), String.downcase(first_name))
      end,
      &>=/2
    )
  end

  def find_player(last_name: last_name) do
    Parser.Player.players()
    |> Enum.filter(fn p ->
      String.jaro_distance(String.downcase(p["last_name"]), String.downcase(last_name)) >
        @minimum_similarity
    end)
    |> Enum.sort_by(
      fn p ->
        String.jaro_distance(String.downcase(p["last_name"]), String.downcase(last_name))
      end,
      &>=/2
    )
  end

  def find_player(full_name: full_name) do
    Parser.Player.players()
    |> Enum.filter(fn p ->
      String.jaro_distance(downcase_full_name(p), String.downcase(full_name)) >
        @minimum_similarity
    end)
    |> Enum.sort_by(
      fn p -> String.jaro_distance(downcase_full_name(p), String.downcase(full_name)) end,
      &>=/2
    )
  end

  def find_player(name) when is_binary(name) do
    case String.contains?(name, " ") do
      true ->
        find_player(full_name: name)

      false ->
        find_player(last_name: name) |> Enum.concat(find_player(first_name: name))
    end
  end

  @doc """
  Returns a single player that best matches the search,
  or nil if no match was found.

      iex> Nba.Data.find_player!("J Holiday")
      %{
        "first_name" => "Jrue",
        "last_name" => "Holiday",
        "player_id" => 201950,
        "team_id" => 1610612740
      }
  """
  @spec find_player!(list(tuple) | String.t) :: map | nil
  def find_player!(first_name: first_name) do
    find_player(first_name: first_name) |> List.first()
  end

  def find_player!(last_name: last_name) do
    find_player(last_name: last_name) |> List.first()
  end

  def find_player!(full_name: full_name) do
    find_player(full_name: full_name) |> List.first()
  end

  def find_player!(name) when is_binary(name) do
    find_player(name) |> List.first()
  end

  defp downcase_full_name(player) do
    (player["first_name"] <> " " <> player["last_name"])
    |> String.downcase()
  end

  @doc """
  Returns a map keyed by month name – the map's values are a list of games scheduled in the corresponding month
  """
  @spec full_year_schedule :: map()
  def full_year_schedule do
    @schedule_url
    |> http().get()
    |> Parser.Data.transform_schedule_response()
  end
end
