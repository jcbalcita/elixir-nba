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

  You can pass in a single key-value pair for first name, last name,
  or full name.

      Nba.find_player(first_name: "brandn")
      Nba.find_player(last_name: "ingram")
      Nba.find_player(full_name: "brandon ingram")

  You may also pass in a string as an argument.

      Nba.find_player("Steph Curry")
      [
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

      iex>
      Nba.find_player!("Steph Curry")
      %{
          "first_name" => "Stephen",
          "last_name" => "Curry",
          "player_id" => 201939,
          "team_id" => 1610612744
        }
  """
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

  def find_player!(name) when is_binary(name) do
    find_player(name) |> List.first()
  end
end
