defmodule Nba.Parser.Data do
  @moduledoc false

  def transform_schedule_response({:ok, schedule_data}) do
    schedule_data["lscd"]
    |> Enum.reduce(%{}, fn m, acc ->
      month_name = m["mscd"]["mon"]
      games_list = m["mscd"]["g"]

      Map.put(acc, month_name, games_list)
    end)
  end

  def transform_schedule_response(_), do: %{}
end
