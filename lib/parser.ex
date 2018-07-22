defmodule ElixirNba.Parser do
  @external_resource json_path = Path.join([__DIR__, "../nba.json"])
  @nba_map with {:ok, body} <- File.read(json_path),
                {:ok, json} <- Poison.decode(body),
                do: json
  @parameters_by_name Enum.reduce(@nba_map["parameters"], %{}, fn p, acc ->
                        Map.put(acc, p["name"], p)
                      end)
  @endpoints_by_name Enum.reduce(@nba_map["stats_endpoints"], %{}, fn p, acc ->
                       Map.put(acc, p["name"], p)
                     end)

  def map, do: @nba_map

  @spec headers :: map()
  def headers, do: @nba_map["headers"]

  @spec parameters :: list(map())
  def parameters, do: @nba_map["parameters"]

  @spec params_by_name :: map()
  def params_by_name, do: @parameters_by_name

  @spec endpoints :: list(map())
  def endpoints, do: @nba_map["stats_endpoints"]

  @spec endpoints_by_name :: map()
  def endpoints_by_name, do: @endpoints_by_name

  @spec defaults_for_these_parameters(list(String.t())) :: map()
  def defaults_for_these_parameters(parameter_names) do
    parameter_names
    |> Enum.map(fn name -> {name, @parameters_by_name[name]["default"]} end)
    |> Enum.into(%{})
  end

  @spec transform_api_response(map()) :: list(map())
  def transform_api_response(:error), do: "Try again!"
  def transform_api_response(json) do
    json["resultSets"]
    |> Enum.map(fn result_set ->
      result_set["rowSet"]
      |> Enum.map(fn row_set ->
        Enum.zip(result_set["headers"], row_set) |> Enum.into(%{})
      end)
    end)
  end
end
