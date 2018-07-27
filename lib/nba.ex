defmodule Nba do
  @moduledoc """
  nba.com uses a large number of undocumented JSON endpoints
  to provide the statistics tables and charts displayed therein.
  This library provides an Elixir client for interacting with many
  of those API endpoints.
  """

  alias Nba.Parser

  @threshold 0.83

  @doc """
  Returns a list of players sorted by best match.

  You can pass in key-value pairs for
  - first name
  - last name
  - full name

      Nba.find_player(first_name: "brandn")
      => [
          %{
            "first_name" => "Brandon",
            "last_name" => "Ingram",
            "player_id" => 1627742,
            "team_id" => 1610612747
          },
          %{
            "first_name" => "Brandon",
            "last_name" => "Knight",
            "player_id" => 202688,
            "team_id" => 1610612756
          }, ...]

    You may also pass in a string as an argument

        Nba.find_player("Steph Curry")
        =>[
          %{
            "first_name" => "Stephen",
            "last_name" => "Curry",
            "player_id" => 201939,
            "team_id" => 1610612744
          },
          %{
            "first_name" => "Seth",
            "last_name" => "Curry",
            "player_id" => 203552,
            "team_id" => 1610612742
          }
          ]
  """
  @spec find_player(list(tuple()) | String.t()) :: list(map())
  def find_player(first_name: first_name) do
    Parser.Player.players()
    |> Enum.filter(fn p ->
      String.jaro_distance(String.downcase(p["first_name"]), String.downcase(first_name)) > @threshold
    end)
    |> Enum.sort_by(fn p ->
      String.jaro_distance(String.downcase(p["first_name"]), String.downcase(first_name))
    end, &>=/2)
  end

  def find_player(last_name: last_name) do
    Parser.Player.players()
    |> Enum.filter(fn p ->
      String.jaro_distance(String.downcase(p["last_name"]), String.downcase(last_name)) > @threshold
    end)
    |> Enum.sort_by(fn p ->
      String.jaro_distance(String.downcase(p["last_name"]), String.downcase(last_name))
    end, &>=/2)
  end

  def find_player(full_name: full_name) do
    Parser.Player.players()
    |> Enum.filter(fn p ->
      candidate = (p["first_name"] <> " " <> p["last_name"]) |> String.downcase()
      String.jaro_distance(candidate, String.downcase(full_name)) > @threshold
    end)
    |> Enum.sort_by(fn p ->
      candidate = (p["first_name"] <> " " <> p["last_name"]) |> String.downcase
      String.jaro_distance(candidate, String.downcase(full_name))
    end, &>=/2)
  end

  def find_player(string) when is_binary(string) do
    case String.contains?(string, " ") do
      true ->
        find_player(full_name: string)
      false ->
        find_player(last_name: string) |> Enum.concat(find_player(first_name: string))
    end
  end

  @spec find_player!(list(tuple()) | String.t()) :: map() | nil
  def find_player!(first_name: first_name) do
    find_player(first_name: first_name) |> List.first()
  end

  def find_player!(last_name: last_name) do
    find_player(last_name: last_name) |> List.first()
  end

  def find_player!(full_name: full_name) do
    find_player(full_name: full_name) |> List.first()
  end

  def find_player!(string) when is_binary(string) do
    find_player(string) |> List.first()
  end
end
