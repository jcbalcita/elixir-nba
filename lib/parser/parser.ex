defmodule Nba.Parser do
  @moduledoc false

  @external_resource json_path = Path.join([__DIR__, "../../data/headers.json"])
  headers =
    with {:ok, body} <- File.read(json_path),
         {:ok, json} <- Poison.decode(body),
         do: json

  @stats_headers Map.merge(headers["common_headers"], headers["stats_headers"])
  @data_headers Map.merge(headers["common_headers"], headers["data_headers"])

  def stats_headers, do: @stats_headers
  def data_headers, do: @data_headers
end
