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
      #=> ["assist_tracker", "box_score", "box_score_summary", ...]
      
  Each endpoint has two corresponding functions, one with an 
  arity of 0 and one with an arity of 1. The 0-arity functions
  return a list of the available query parameters for 
  its endpoint.

      ElixirNba.player_info()
      #=> ["PlayerID", "SeasonType", "LeagueID"]

  Now that you know what query params you can pass, let's make
  a call to the endpoint by passing in a map of query param 
  key/values.

      ElixirNba.player_info(%{"PlayerID" => "1627742"})

  If you need example values for a query param, use
  `ElixirNba.param_values_for/1`.

      ElixirNba.param_values_for("AheadBehind")
      #=> ["Ahead or Behind", "Ahead or Tied", "Behind or Tied", ""]
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

  @spec available_functions() :: list(atom())
  def available_functions() do
    __MODULE__.__info__(:functions)
    |> Enum.filter(fn {_, arity} -> arity > 0 end)
    |> Enum.map(fn {name, _} -> name end)
  end

  @spec param_values_for(String.t()) :: list(String.t())
  def param_values_for(param_name) do
    param = Parser.params_by_name()[param_name]
    if param == nil, do: ["No such param found"], else: param["values"]
  end
end
