defmodule ElixirNba do
  alias ElixirNba.Parser

  @moduledoc """
   Elixir implementation of bttmly/nba-client-template
  """

  Parser.endpoints()
  |> Enum.each(fn endpoint ->
    name = endpoint["name"]
    url = endpoint["url"]

    def unquote(:"#{name}")(), do: unquote(url)
  end)
end
