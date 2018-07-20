defmodule ElixirNba do
  alias ElixirNba.Parser
  alias ElixirNba.QueryString

  @moduledoc """
   Elixir implementation of bttmly/nba-client-template
  """

  @http Application.get_env(:elixir_nba, :http)

  Parser.endpoints()
  |> Enum.each(fn endpoint ->
    name = endpoint["name"]
    url = endpoint["url"]

    def unquote(:"#{name}")(_map) do
      url = unquote(url)
      @http.get(url)

      url
    end

  end)
end
