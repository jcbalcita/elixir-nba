defmodule Nba.FakeBadHttp do
  def get(_, _), do: {:error, "you done messed up"}
end