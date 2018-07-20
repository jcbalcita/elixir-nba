defmodule ElixirNba.Parser do
  @external_resource json_path = Path.join([__DIR__, "../nba.json"])
  @nba_map with {:ok, body} <- File.read(json_path),
                {:ok, json} <- Poison.decode(body),
                do: json
  @parameters_by_name Enum.reduce(@nba_map["parameters"], %{}, fn p, acc ->
                        Map.put(acc, p["name"], p)
                      end)

  def map, do: @nba_map

  @spec parameters :: list(map())
  def parameters, do: @nba_map["parameters"]

  @spec endpoints :: list(map())
  def endpoints, do: @nba_map["stats_endpoints"]

  @spec headers :: map()
  def headers, do: @nba_map["headers"]

  @spec parameters_by_name :: map()
  def parameters_by_name, do: @parameters_by_name

  @spec defaults_for_these_parameters(list(String.t())) :: map()
  def defaults_for_these_parameters(parameter_names) do
    parameter_names
    |> Enum.map(fn p -> {p, @parameters_by_name[p]["default"]} end)
    |> Enum.into(%{})
  end
end
