defmodule Nba.Data do
  def http, do: Application.get_env(:nba, :http_data, Nba.Http.Data)
end
