defmodule ElixirNba.FakeHttp do
  @result %{
    "player" => "JC Balcita",
    "points_per_game" => "50.55",
    "assists_per_game" => "10.5"
  }

  def get(url) do
    case URI.parse(url) do
      %URI{scheme: nil} -> {:error, url}
      %URI{host: nil} -> {:error, url}
      %URI{path: nil} -> {:error, url}
      uri -> {:ok, @result}
    end
  end
end
