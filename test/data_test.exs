defmodule Nba.DataTest do
  use ExUnit.Case
  doctest Nba.Data

  Application.put_env(:nba, :http_data, Nba.FakeHttp.Data)
end
