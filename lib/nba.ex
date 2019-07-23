defmodule Nba do
  @moduledoc """
  nba.com uses a large number of undocumented JSON endpoints
  to provide the statistics tables and charts displayed therein.
  This library provides an Elixir client for interacting with many
  of those API endpoints.

  This app is built from json files at compile time. You can configure the
  paths of `endpoints` and `players` json files that elixir-nba reads.

  ```
  config :nba, endpoint_json_path: "/Users/me/my/custom/path/endpoints.json"
  config :nba, player_json_path: "/Users/me/my/custom/path/players.json"
  ```
  Now you don't have to wait until I publish a release to fix endpoint issues,
  and can tweak the default parameter values, among other things. Keep in mind
  that the shape of the data must stay the same (see `data/players.json` and
  `data/endpoints.json`).
  """

  @doc """
  Returns the JSON encoding library, which by default is Jason.

  To configure this application to use another JSON encoding library,
  namely Poison, include the following in your `config/config.exs`:

      config :nba, :json_library, Poison
  """
  def json_library, do: Application.get_env(:nba, :json_library, Jason)
end
