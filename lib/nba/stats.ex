defmodule Nba.Stats do
  @moduledoc """
  Provides a function for each stats.nba.com endpoint.

  ## Examples
  See what endpoints you can hit:

      Nba.Stats.endpoints()
      #=> [:assist_tracker:, :box_score:, :box_score_summary:, ...]

  Pass in the atom `:help` as a parameter to an endpoint function
  to get a list of the available query parameters for the endpoint.

      Nba.Stats.player_profile(:help)
      #=> [:LeagueID, :PerMode, :PlayerID]

  If you need example values for a query param, use `Nba.Stats.values_for/1`.

      Nba.Stats.values_for("PerMode")
      #=> ["Totals", "PerGame", "MinutesPer", "Per36"]

  Boilerplate default values should be filled in for the most part, but as the API is
  always changing, the app may not fill in all the values correctly. Pay attention to
  the error message to see what was missing from the API call.

      Nba.Stats.player_profile()
      #=> {:error, "PlayerID is required"}

  Now that you know what query params you can pass, we can make a call to the endpoint
  by passing in a list of tuples to the endpoint function. Alternatively, you have the
  option of passing in a map.

      Nba.Stats.player_profile(PlayerID: 1628366, PerMode: "Totals")
      #=> {:ok, %{"CareerHighs" => ...}}

      Nba.Stats.player_profile(%{"PlayerID" => 1628366, "PerMode" => "Totals"})
      #=> {:ok, %{"CareerHighs" => ...}}

      Nba.Stats.player_profile(PlayerID: "Go Bruins")
      #=> {:error, "The value 'Go Bruins' is not valid for PlayerID.; PlayerID is required"}

  Note: The functions with a `!` raise an exception if the API call results in an error.

      Nba.Stats.player_profile!(PlayerID: "Go Bruins")
      #=> ** (RuntimeError) The value 'Go Bruins' is not valid for PlayerID.; PlayerID is required
  """

  alias Nba.Parser
  alias Nba.Http

  defp http, do: Application.get_env(:nba, :http, Nba.Http)

  Parser.Stats.endpoints()
  |> Enum.each(fn endpoint ->
    name = endpoint["name"]

    def unquote(:"#{name}")(user_input \\ %{})

    @spec unquote(:"#{name}")(:help) :: list(String.t())
    def unquote(:"#{name}")(:help) do
      Parser.Stats.endpoints_by_name()
      |> Map.get(unquote(name))
      |> Map.get("parameters")
      |> Enum.sort()
      |> Enum.map(&String.to_atom/1)
    end

    @spec unquote(:"#{name}")(map) :: {:ok | :error, map | String.t}
    def unquote(:"#{name}")(user_input_map) when is_map(user_input_map) do
      endpoint = Parser.Stats.endpoints_by_name()[unquote(name)]
      valid_keys = Map.get(endpoint, "parameters")
      url = Map.get(endpoint, "url")
      query_string = build_query_string(user_input_map, valid_keys)

      (url <> query_string)
      |> http().get(Parser.headers())
      |> Parser.Stats.transform_api_response()
    end

    @spec unquote(:"#{name}")(list(tuple)) :: {:ok | :error, map | String.t}
    def unquote(:"#{name}")(options) when is_list(options) do
      apply(__MODULE__, :"#{unquote(name)}", [Enum.into(options, %{})])
    end

    @spec unquote(:"#{name}!")(map) :: map
    def unquote(:"#{name}!")(user_input_map \\ %{}) do
      case apply(__MODULE__, :"#{unquote(name)}", [user_input_map]) do
        {:ok, result} -> result
        {:error, error} -> raise %RuntimeError{message: error}
        _ -> raise %RuntimeError{message: "Error calling API"}
      end
    end
  end)

  @spec endpoints() :: list(atom)
  @doc "Returns a list of atoms, one for each endpoint function in the Stats module"
  def endpoints() do
    Parser.Stats.endpoints()
    |> Enum.map(&Map.get(&1, "name"))
    |> Enum.map(&String.to_atom/1)
  end

  @spec values_for(String.t | atom) :: list(String.t)
  @doc "Returns a list of valid query param keys for an endpoint"
  def values_for(param_name) do
    param = Parser.Stats.params_by_name()["#{param_name}"]
    if param, do: param["values"], else: []
  end

  @doc false
  def build_query_string(user_input_map, valid_keys) do
    str_keyed =
      user_input_map
      |> Map.new(fn {k, v} -> {Atom.to_string(k), v} end)

    default_values_for(valid_keys)
    |> Map.merge(str_keyed)
    |> Http.query_string_from_map()
  end

  @spec default_values_for(list(String.t)) :: map
  defp default_values_for(parameter_keys) do
    parameter_keys
    |> Enum.reduce(%{}, fn key, acc ->
      default_value = Parser.Stats.params_by_name() |> Map.get(key) |> Map.get("default")
      Map.put(acc, key, default_value)
    end)
  end
end
