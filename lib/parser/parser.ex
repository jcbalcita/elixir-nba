defmodule Nba.Parser do
  @moduledoc false

  @external_resource json_path = Path.join([__DIR__, "../../data/headers.json"])
  @headers with {:ok, body} <- File.read(json_path),
                {:ok, data} <- Nba.json_library().decode(body),
                do: data["headers"]

  def headers, do: @headers
end
