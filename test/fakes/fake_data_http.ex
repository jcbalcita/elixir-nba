defmodule Nba.FakeHttp.Data do
  alias Nba.Json

  @external_resource json_path = Path.join([__DIR__, "simple_schedule_response.json"])
  @response with {:ok, body} <- File.read(json_path),
                 {:ok, json} <- Json.decode(body),
                 do: json

  def get(url) do
    case URI.parse(url) do
      %URI{scheme: nil} -> {:error, "bad url"}
      %URI{host: nil} -> {:error, "bad url"}
      %URI{path: nil} -> {:error, "bad url"}
      _ -> {:ok, @response}
    end
  end
end
