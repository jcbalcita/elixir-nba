defmodule Nba.Http.QueryString do
  @moduledoc false

  @spec build(map()) :: String.t()
  def build(parameter_map), do: "?" <> URI.encode_query(parameter_map)
end
