defmodule Nba.Parser.Stats do
  @moduledoc false

  @external_resource json_path = Path.join([__DIR__, "../../data/nba.json"])
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
  def endpoints, do: @endpoints["stats_endpoints"]

  @spec endpoints_by_name :: map()
  def endpoints_by_name(), do: @endpoints_by_name

  @spec transform_api_response({:ok | :error, map() | String.t()}) :: map() | tuple()
  def transform_api_response({:ok, api_response}) do
    case {api_response["resultSet"], api_response["resultSets"]} do
      {nil, nil} ->
        {:error, "Error calling API"}

      {nil, result_sets} ->
        build_and_zip(result_sets)

      {result_set, nil} ->
        key = result_set["name"]

        value =
          zip_single_row_set(result_set["rowSet"], result_set["headers"])
          |> Enum.map(&Enum.into(&1, %{}))

        {:ok, %{key => value}}
    end
  end

  def transform_api_response({:error, message}), do: {:error, message}

  defp zip_single_row_set(row_set, headers) do
    Enum.map(row_set, &Enum.zip(headers, &1))
  end

  defp build_and_zip(result_sets) when is_list(result_sets) do
    result =
      Enum.reduce(result_sets, %{}, fn result_set, acc ->
        key = result_set["name"]

        value =
          zip_single_row_set(result_set["rowSet"], result_set["headers"])
          |> Enum.map(&Enum.into(&1, %{}))

        Map.put(acc, key, value)
      end)

    {:ok, result}
  end

  defp build_and_zip(result_sets) when is_map(result_sets) do
    [base_columns | parent_column_groups] = result_sets["headers"] |> Enum.reverse()
    ungrouped_rows = zip_single_row_set(result_sets["rowSet"], base_columns["columnNames"])

    result_key = result_sets["name"]

    result_value =
      group_columns(parent_column_groups, ungrouped_rows)
      |> Enum.map(&Enum.into(&1, %{}))

    {:ok, %{result_key => result_value}}
  end

  defp build_and_zip(_), do: {:error, "Error parsing response"}

  defp group_columns([], result), do: result

  defp group_columns([group | rest], list_of_rows) do
    cols_to_skip = group["columnsToSkip"]
    group_size = group["columnSpan"]
    group_names = group["columnNames"]

    updated_list =
      Enum.map(list_of_rows, fn row ->
        {skipped, to_group} = Enum.split(row, cols_to_skip)
        chunks = Enum.chunk_every(to_group, group_size)
        grouped = group_and_convert(group_names, chunks, [])

        Enum.concat(skipped, grouped)
      end)

    group_columns(rest, updated_list)
  end

  defp group_and_convert([], _, result), do: result

  defp group_and_convert(_, [], result), do: result

  defp group_and_convert([group_name | groups], [chunk | chunks], result) do
    new_result = [{group_name, Enum.into(chunk, %{})} | result]
    group_and_convert(groups, chunks, new_result)
  end
end
