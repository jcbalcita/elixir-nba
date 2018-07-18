defmodule ElixirNba.QueryString do
  @moduledoc """
  Builds query string for API call
  """

  @spec filter_invalid_keys(map(), list(String.t())) :: map()
  def filter_invalid_keys(parameter_map, valid_parameters) do
    parameter_map
    |> Enum.filter(fn {k, v} -> Enum.member?(valid_parameters, k) && String.length(v) > 0 end)
  end

  @spec build(map(), list(String.t())) :: String.t()
  def build(parameter_map, valid_parameters) do
    query_string =
      parameter_map
      |> filter_invalid_keys(valid_parameters)
      |> URI.encode_query()

    "?" <> query_string
  end
end
