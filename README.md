# ElixirNba
  https://hex.pm/packages/nba/


  Elixir implementation of bttmly/nba-client-template

  stats.nba.com uses a large number of undocumented JSON endpoints
  to provide the statistics tables and charts displayed therein.
  This library provides an Elixir client for interacting with many
  of those API endpoints.

  Currently, only the `stats` namespace is available via this library.
  `sportsVu` and `synergy` namespaces are on the todo list.

  ## Installation

  Add NBA to your mix.exs dependencies:

  ```elixir
  def deps do
    [{:nba, "~> 0.7"}]
  end
  ```

  ## Examples
  See what endpoints you can hit:

  ```elixir
    Nba.Stats.endpoints()
    #=> [:assist_tracker:, :box_score:, :box_score_summary:, ...]
  ```

  Pass in the atom `:help` as a parameter to an endpoint function
  to get a list of the available query parameters for the endpoint.

  ```elixir
    Nba.Stats.player_profile(:help)
    #=> [:LeagueID, :PerMode, :PlayerID]
  ```
  If you need example values for a query param, use `Nba.Stats.values_for/1`.

  ```elixir
    Nba.Stats.values_for("PerMode")
    #=> ["Totals", "PerGame", "MinutesPer", "Per36"]
  ```

  Boilerplate default values should be filled in for the most part, but as the API is
  always changing, the app may not fill in all the values correctly. Pay attention to
  the error message to see what was missing from the API call.

  ```elixir
      Nba.Stats.player_profile()
      #=> {:error, "PlayerID is required"}
  ```

  Now that you know what query params you can pass, we can make a call to the endpoint
  by passing in a list of tuples to the endpoint function. Alternatively, you have the
  option of passing in a map.

  ```elixir
    Nba.Stats.player_profile(PlayerID: 1628366, PerMode: "Totals")
    #=> {:ok, %{"CareerHighs" => ...}}

    Nba.Stats.player_profile(%{"PlayerID" => 1628366, "PerMode" => "Totals"})
    #=> {:ok, %{"CareerHighs" => ...}}

    Nba.Stats.player_profile(PlayerID: "Go Bruins")
    #=> {:error, "The value 'Go Bruins' is not valid for PlayerID.; PlayerID is required"
  ```
  Note: The functions with a `!` raise an exception if the API call results in an error.

  ```elixir
    Nba.Stats.player_profile!(PlayerID: "Go Bruins")
    #=> ** (RuntimeError) The value 'Go Bruins' is not valid for PlayerID.; PlayerID is required
  ```