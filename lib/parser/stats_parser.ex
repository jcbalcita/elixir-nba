defmodule Nba.Parser.Stats do
  @moduledoc false

  @external_resource json_path = Path.join([__DIR__, "../../data/nba.json"])
  @endpoints with {:ok, body} <- File.read(json_path),
                  {:ok, json} <- Poison.decode(body),
                  do: json
  @endpoints_by_name Enum.reduce(@endpoints["stats_endpoints"], %{}, fn p, acc ->
                       Map.put(acc, p["name"], p)
                     end)
  @params_by_name Enum.reduce(@endpoints["parameters"], %{}, fn p, acc ->
                    Map.put(acc, p["name"], p)
                  end)

  @spec parameters :: list(map())
  def parameters, do: @endpoints["parameters"]

  @spec params_by_name :: map()
  def params_by_name, do: @params_by_name

  @spec endpoints :: map()
  def endpoints, do: @endpoints["stats_endpoints"]

  @spec endpoints_by_name :: map()
  def endpoints_by_name(), do: @endpoints_by_name

  @spec transform_api_response({atom(), map()}) :: map()
  def transform_api_response({:ok, json}) do
    result_sets = if json["resultSets"], do: json["resultSets"], else: [json["resultSet"]]

    result_sets
    |> Enum.reduce(%{}, fn result_set, acc ->
      name = result_set["name"]

      values =
        result_set["rowSet"]
        |> Enum.map(fn row_set ->
          Enum.zip(result_set["headers"], row_set) |> Enum.into(%{})
        end)

      Map.put(acc, name, values)
    end)
  end

  def transform_api_response({:error, message}), do: %{error: message}
  def transform_api_response(_), do: %{}
end
