defmodule ElixirNba.QueryString do
  @moduledoc """
  Builds query string for API call
  """

  @spec build(map()) :: String.t()
  def build(parameter_map) do
    query_string =
      parameter_map
      |> Enum.map_join("&", fn {k, v} -> k <> "=" <> v end)

    "?" <> query_string
  end

end
