defmodule ElixirNba.Http do
  alias ElixirNba.Parser

  @headers Parser.headers()

  def get(url), do: HTTPoison.get(url, @headers)
end
