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
    params = endpoint["parameters"]

    def unquote(:"#{name}")() do
      unquote(params)
      |> Enum.chunk_every(5)
      |> Enum.each(fn chunk -> Enum.join(chunk, " | ") |> IO.puts() end)
    end

    def unquote(:"#{name}")(user_input) do
      endpoint_name = __ENV__.function |> elem(0) |> Atom.to_string()
      endpoint = Parser.endpoints_by_name()[endpoint_name]
      url = endpoint["url"]
      valid_params = endpoint["parameters"]

      query_string =
        Parser.defaults_for_these_parameters(valid_params)
        |> Map.merge(user_input)
        |> QueryString.build(valid_params)

      (url <> query_string)
      |> @http.get()
    end
  end)
end
