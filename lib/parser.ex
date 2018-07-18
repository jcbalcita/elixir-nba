defmodule ElixirNba.Parser do
  @external_resource json_path = Path.join([__DIR__, "../nba.json"])
  @nba_map with {:ok, body} <- File.read(@external_resource),
                {:ok, json} <- Poison.decode(body),
                do: json

  def map, do: @nba_map
  def parameters, do: @nba_map["parameters"]
  def endpoints, do: @nba_map["stats_endpoints"]
end
