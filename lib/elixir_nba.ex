defmodule ElixirNba do
  @moduledoc """
  Elixir implementation of bttmly/nba-client-template

  stats.nba.com uses a large number of undocumented JSON endpoints 
  to provide the statistics tables and charts displayed therein. 
  This library provides an Elixir client for interacting with many 
  of those API endpoints.

  ## Examples
  See what endpoints you can hit:
      
      ElixirNba.available_functions()
      #=> ["assist_tracker/1", "box_score/1", "box_score_summary/1", ...]
      
  Each of these endpoint functions has a corresponding function with 
  an arity of 0 that returns a list of the query parameters for 
  the endpoint.

      ElixirNba.player_info()
      #=> ["PlayerID", "SeasonType", "LeagueID"]

  Now that you know what query params you can pass, let's make
  a call to the endpoint. The endpoint functions take in one
  argument, a `map()` of query param key/values.

      ElixirNba.player_info(%{"PlayerID" => "1627742"})
  """

  alias ElixirNba.Parser
  alias ElixirNba.QueryString

  @http Application.get_env(:elixir_nba, :http)

  Parser.endpoints()
  |> Enum.each(fn endpoint ->
    name = endpoint["name"]

    def unquote(:"#{name}")() do
      endpoint_name = __ENV__.function |> elem(0) |> Atom.to_string()
      endpoint = Parser.endpoints_by_name()[endpoint_name]

      endpoint["parameters"]
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
      |> Parser.transform_api_response()
    end
  end)

  @spec available_functions() :: list(String.t())
  def available_functions() do
    functions =
      __MODULE__.__info__(:functions)
      |> Enum.filter(fn {_, arity} ->
        arity > 0
      end)
      |> Enum.map(fn {name, arity} ->
        "#{name}/#{arity}"
      end)

    Enum.each(functions, &IO.puts(&1))

    functions
  end
end
