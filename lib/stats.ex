defmodule Nba.Stats do
  @moduledoc """
  Provides a function for each stats.nba.com endpoint.

  ## Examples
  See what endpoints you can hit:

      Nba.Stats.endpoints()
      #=> ["assist_tracker", "box_score", "box_score_summary", ...]

  Each endpoint has two corresponding functions, one with an
  arity of 0 and one with an arity of 1. The 0-arity functions
  return a list of the available query parameters for
  its endpoint.

      Nba.Stats.player_info()
      #=> ["PlayerID", "SeasonType", "LeagueID"]

  Now that you know what query params you can pass, let's make
  a call to the endpoint by passing in a map of query param
  key/values.

      Nba.Stats.player_info(%{"PlayerID" => "1627742"})

  If you need example values for a query param, use
  `Nba.Stats.param_values_for/1`.

      Nba.Stats.param_values_for("AheadBehind")
      #=> ["Ahead or Behind", "Ahead or Tied", "Behind or Tied", ""]
  """

  alias Nba.Parser
  alias Nba.QueryString

  @http Application.get_env(:nba, :http, Nba.Http)

  Parser.Stats.endpoints("stats")
  |> Enum.each(fn endpoint ->
    name = endpoint["name"]

    @spec unquote(:"#{name}")() :: list(String.t())
    def unquote(:"#{name}")() do
      endpoint_name = __ENV__.function |> elem(0) |> Atom.to_string()
      endpoint = Parser.Stats.endpoints_by_name("stats")[endpoint_name]

      endpoint["parameters"]
    end

    @spec unquote(:"#{name}")(map()) :: map()
    def unquote(:"#{name}")(user_input_map) do
      endpoint_name = __ENV__.function |> elem(0) |> Atom.to_string()
      endpoint = Parser.Stats.endpoints_by_name("stats")[endpoint_name]
      url = endpoint["url"]
      valid_params = endpoint["parameters"]

      query_string =
        defaults_for_these_parameters(valid_params)
        |> Map.merge(user_input_map)
        |> QueryString.build(valid_params)

      (url <> query_string)
      |> @http.Stats.get()
      |> Parser.Stats.transform_api_response()
    end
  end)

  @spec endpoints() :: list(atom())
  def endpoints() do
    __MODULE__.__info__(:functions)
    |> Enum.filter(fn {_, arity} -> arity > 0 end)
    |> Enum.map(fn {name, _} -> name end)
  end

  @spec param_values_for(String.t()) :: list(String.t())
  def param_values_for(param_name) do
    param = Parser.Stats.params_by_name()[param_name]
    if param == nil, do: ["No such param found"], else: param["values"]
  end

  @spec defaults_for_these_parameters(list(String.t())) :: map()
  defp defaults_for_these_parameters(parameter_names) do
    parameter_names
    |> Enum.map(fn name -> {name, Parser.Stats.params_by_name()[name]["default"]} end)
    |> Enum.into(%{})
  end
end
