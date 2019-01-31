defmodule Nba do
  @moduledoc """
  nba.com uses a large number of undocumented JSON endpoints
  to provide the statistics tables and charts displayed therein.
  This library provides an Elixir client for interacting with many
  of those API endpoints.
  """

  @doc """
  Returns the JSON encoding library, which by default is Jason.

  To configure this application to use another JSON encoding library,
  namely Poison, include the following in your `config/config.exs`:

      config :nba, :json_library, Poison
  """
  def json_library, do: Application.get_env(:nba, :json_library, Jason)
end
