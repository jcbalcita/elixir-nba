defmodule Nba.Parser.Stats do
    @moduledoc false

    @external_resource json_path = Path.join([__DIR__, "../../nba.json"])
    @endpoints with {:ok, body} <- File.read(json_path),
                    {:ok, json} <- Poison.decode(body), 
                    do: json
    @params_by_name Enum.reduce(@endpoints["parameters"], %{}, fn p, acc ->
                      Map.put(acc, p["name"], p)
                    end)
    @endpoints_by_name Enum.reduce(@endpoints["stats_endpoints"], %{}, fn p, acc ->
                               Map.put(acc, p["name"], p)
                             end)

    @spec parameters :: list(map())
    def parameters, do: @endpoints["parameters"]

    @spec params_by_name :: map()
    def params_by_name, do: @params_by_name

    @spec endpoints :: map()
    def endpoints, do: @endpoints

    @spec endpoints(String.t()) :: list(map())
    def endpoints(type), do: @endpoints["#{type}_endpoints"]

    @spec endpoints_by_name(String.t()) :: map()
    def endpoints_by_name("stats"), do: @endpoints_by_name
    def endpoints_by_name(_), do: @endpoints_by_name


    @spec transform_api_response({atom(), map()}) :: map()
    def transform_api_response({:ok, json}) do
      result_sets =
        case json["resultSets"] do
          nil -> [json["resultSet"]]
          _ -> json["resultSets"]
        end

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

    def transform_api_response(_), do: %{}
  end