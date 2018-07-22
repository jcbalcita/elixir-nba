defmodule ElixirNba.QueryString do
  @moduledoc """
  Builds query string for API call
  """

  @spec build(map(), list(String.t())) :: String.t()
  def build(parameter_map, valid_parameters) do
    query_string =
      parameter_map
      |> filter_invalid_keys(valid_parameters)
      |> URI.encode_query()

    "?" <> query_string
  end

  @spec filter_invalid_keys(map(), list(String.t())) :: map()
  defp filter_invalid_keys(parameters, valid_parameters) do
    parameters
    |> Enum.filter(fn {k, _} -> Enum.member?(valid_parameters, k) end)
  end
end
