defmodule Nba.Data do
  alias Nba.Parser

  @schedule_url "https://data.nba.com/data/10s/v2015/json/mobile_teams/nba/2018/league/00_full_schedule_week.json"

  def http, do: Application.get_env(:nba, :http_data, Nba.Http.Data)

  def full_year_schedule do
    @schedule_url
    |> http().get()
    |> Parser.Data.transform_schedule_response()
  end
end
