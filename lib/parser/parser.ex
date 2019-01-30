defmodule Nba.Parser do
  @moduledoc false
  alias Nba.Json

  @external_resource json_path = Path.join([__DIR__, "../../data/headers.json"])
  @headers with {:ok, body} <- File.read(json_path),
                {:ok, json} <- Json.decode(body),
                do: json["headers"]

  def headers, do: @headers
end
