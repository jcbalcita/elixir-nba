defmodule Nba.Http.QueryString do
  @moduledoc false

  @spec build(map()) :: String.t()
  def build(parameter_map), do: "?" <> URI.encode_query(parameter_map)

  @spec build(map(), list(String.t())) :: String.t()
  def build(parameter_map, valid_keys) do
    query_string =
      parameter_map
      |> filter_invalid_keys(valid_keys)
      |> URI.encode_query()

    "?" <> query_string
  end

  defp filter_invalid_keys(parameters, valid_keys) do
    parameters
    |> Enum.filter(fn {key, _} -> Enum.member?(valid_keys, key) end)
  end
end
