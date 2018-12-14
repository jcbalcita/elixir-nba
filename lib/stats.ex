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

  defp http, do: Application.get_env(:nba, :http_stats, Nba.Http.Stats)

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
      endpoint = Parser.Stats.endpoints_by_name() |> Map.get(unquote(name))
      {url, valid_params} = {Map.get(endpoint, "url"), Map.get(endpoint, "parameters")}

      query_string =
        defaults_for_these_parameters(valid_params)
        |> Map.merge(user_input_map)
        |> QueryString.build(valid_params)

      (url <> query_string)
      |> http().get()
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
    if param, do: param["values"], else: []
  end

  @spec defaults_for_these_parameters(list(String.t())) :: map()
  defp defaults_for_these_parameters(parameter_names) do
    parameter_names
    |> Enum.map(fn name ->
      default = Parser.Stats.params_by_name() |> Map.get(name) |> Map.get("default")
      {name, default}
    end)
    |> Enum.into(%{})
  end
end
