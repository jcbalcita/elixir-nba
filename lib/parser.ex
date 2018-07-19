defmodule ElixirNba.Parser do
  @external_resource json_path = Path.join([__DIR__, "../nba.json"])
  @nba_map with {:ok, body} <- File.read(json_path),
                {:ok, json} <- Poison.decode(body),
                do: json

  def map, do: @nba_map

  @spec parameters :: list(map())
  def parameters, do: @nba_map["parameters"]

  @spec endpoints :: list(map())
  def endpoints, do: @nba_map["stats_endpoints"]

  @spec headers :: map()
  def headers do
    ["user_agent", "referrer", "referer", "origin"]
    |> Enum.map(fn h -> {h, @nba_map[h]} end)
    |> Enum.into(%{})
  end
end
