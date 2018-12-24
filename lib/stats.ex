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
  alias Nba.Http.QueryString

  defp http, do: Application.get_env(:nba, :http, Nba.Http)

  Parser.Stats.endpoints()
  |> Enum.each(fn endpoint ->
    name = endpoint["name"]

    @spec unquote(:"#{name}")() :: list(String.t())
    def unquote(:"#{name}")() do
      Parser.Stats.endpoints_by_name()
      |> Map.get(unquote(name))
      |> Map.get("parameters")
    end

    @spec unquote(:"#{name}")(map()) :: map()
    def unquote(:"#{name}")(user_input_map) do
      with endpoint <- Parser.Stats.endpoints_by_name[unquote(name)],
           valid_params <- Map.get(endpoint, "parameters"),
           url <- Map.get(endpoint, "url"),
           query_string <- build_query_string(user_input_map, valid_params) do

        (url <> query_string)
        |> http().get(Parser.headers())
        |> Parser.Stats.transform_api_response()
      end
    end
  end)

  @spec endpoints() :: list(atom())
  def endpoints() do
    Parser.Stats.endpoints()
    |> Enum.map(&Map.get(&1, "name"))
    |> Enum.map(&String.to_atom/1)
  end

  @spec param_values_for(String.t()) :: list(String.t())
  def param_values_for(param_name) do
    param = Parser.Stats.params_by_name()[param_name]
    if param, do: param["values"], else: []
  end

  defp build_query_string(user_input_map, valid_params) do
    defaults_for_these_parameters(valid_params)
    |> Map.merge(user_input_map)
    |> QueryString.build(valid_params)
  end

  @spec defaults_for_these_parameters(list(String.t())) :: map()
  defp defaults_for_these_parameters(parameter_names) do
    parameter_names
    |> Enum.reduce(%{}, fn name, acc ->
      default = Parser.Stats.params_by_name() |> Map.get(name) |> Map.get("default")
      Map.put(acc, name, default)
    end)
  end
end
