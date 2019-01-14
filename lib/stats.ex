defmodule Nba.Stats do
  @moduledoc """
  Provides a function for each stats.nba.com endpoint.

  ## Examples
  See what endpoints you can hit:

      Nba.Stats.endpoints()
      #=> [:assist_tracker:, :box_score:, :box_score_summary:, ...]

  Each endpoint has a corresponding function with an arity of 0 that
  returns a list of the available query parameters for the endpoint.

      Nba.Stats.player_profile()
      #=> ["LeagueID", "PerMode", "PlayerID"]

  If you need example keys for a query param, use `Nba.Stats.keys_for/1`.
  Note that you do not necessarily need to pass in values for all the keys listed.

      Nba.Stats.keys_for("PerMode")
      #=> ["Totals", "PerGame", "MinutesPer", "Per48", ...]

  Now that you know what query params you can pass, let's make
  a call to the endpoint by passing in a map of query param
  key/values. The functions with a `!` raise an exception if the
  API call results in an error.

      Nba.Stats.player_profile(%{"PlayerID" => 1628366})
      #=> {:ok, %{"CareerHighs" => ...}}

      Nba.Stats.player_profile(%{"PlayerID" => "Go Bruins"})
      #=> {:error, "The value 'Go Bruins' is not valid for PlayerID.; PlayerID is required"}

      Nba.Stats.player_profile!(%{"PlayerID" => 1628366})
      #=> %{"CareerHighs" => ...}

      Nba.Stats.player_profile!(%{"PlayerID" => "Go Bruins"})
      #=> ** (RuntimeError) The value 'Go Bruins' is not valid for PlayerID.; PlayerID is required
  """

  alias Nba.Parser
  alias Nba.Http.QueryString

  defp http, do: Application.get_env(:nba, :http, Nba.Http)

  Parser.Stats.endpoints()
  |> Enum.each(fn endpoint ->
    name = endpoint["name"]

    @spec unquote(:"#{name}")() :: list(String.t())
    @doc false
    def unquote(:"#{name}")() do
      Parser.Stats.endpoints_by_name()
      |> Map.get(unquote(name))
      |> Map.get("parameters")
      |> Enum.sort()
    end

    @spec unquote(:"#{name}")(map()) :: {:ok | :error, map() | String.t()}
    def unquote(:"#{name}")(user_input_map) when is_map(user_input_map) do
      endpoint = Parser.Stats.endpoints_by_name()[unquote(name)]
      valid_keys = Map.get(endpoint, "parameters")
      url = Map.get(endpoint, "url")
      query_string = build_query_string(user_input_map, valid_keys)

      (url <> query_string)
      |> http().get(Parser.headers())
      |> Parser.Stats.transform_api_response()
    end

    @spec unquote(:"#{name}!")(map()) :: map()
    def unquote(:"#{name}!")(user_input_map) do
      case apply(__MODULE__, :"#{unquote(name)}", [user_input_map]) do
        {:ok, result} -> result
        {:error, error} -> raise %RuntimeError{message: error}
        _ -> raise %RuntimeError{message: "Error calling API"}
      end
    end
  end)

  @spec endpoints() :: list(atom())
  @doc "Returns a list of atoms, one for each endpoint function in the Stats module"
  def endpoints() do
    Parser.Stats.endpoints()
    |> Enum.map(&Map.get(&1, "name"))
    |> Enum.map(&String.to_atom/1)
  end

  @spec keys_for(String.t()) :: list(String.t())
  @doc "Returns a list of valid query param keys for an endpoint"
  def keys_for(param_name) do
    param = Parser.Stats.params_by_name()[param_name]
    if param, do: param["values"], else: []
  end

  defp build_query_string(user_input_map, valid_keys) do
    default_values_for(valid_keys)
    |> Map.merge(user_input_map)
    |> QueryString.build(valid_keys)
  end

  @spec default_values_for(list(String.t())) :: map()
  defp default_values_for(parameter_keys) do
    parameter_keys
    |> Enum.reduce(%{}, fn key, acc ->
      default_value = Parser.Stats.params_by_name() |> Map.get(key) |> Map.get("default")
      Map.put(acc, key, default_value)
    end)
  end
end
