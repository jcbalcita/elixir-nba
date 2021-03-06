defmodule Nba.Parser.Player do
  @moduledoc false

  @external_resource json_path =
                       Application.get_env(
                         :nba,
                         :player_json_path,
                         Path.join([__DIR__, "../../../data/players.json"])
                       )

  @players with {:ok, body} <- File.read(json_path),
                {:ok, data} <- Nba.json_library().decode(body),
                do:
                  Enum.map(data, fn p ->
                    Map.new(p, fn {k, v} -> {Macro.underscore(k), v} end)
                  end)
  @players_by_id Enum.reduce(@players, %{}, fn p, acc ->
                   Map.put(acc, p["player_id"], p)
                 end)

  @spec players :: list(map)
  def players, do: @players

  @spec players_by_id :: map
  def players_by_id, do: @players_by_id
end
