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
    [{:nba, "~> 0.5.0"}]
  end
  ```

  ## Examples
  See what endpoints you can hit:

  ```elixir
    Nba.Stats.endpoints()
    #=> [:assist_tracker:, :box_score:, :box_score_summary:, ...]
  ```

  Each endpoint has a corresponding function with an arity of 0 that
  returns a list of the available query parameters for the endpoint.

  ```elixir
    Nba.Stats.player_profile()
    #=> ["LeagueID", "PerMode", "PlayerID"]
  ```
  If you need example values for a query param, use `Nba.Stats.param_values_for/1`.

  ```elixir
    Nba.Stats.param_values_for("PerMode")
    #=> ["Totals", "PerGame", "MinutesPer", "Per48", "Per40", "Per36", "PerMinute", "PerPossession", "PerPlay", "Per100Possessions", "Per100Plays"]
  ```
      
  Now that you know what query params you can pass, let's make
  a call to the endpoint by passing in a map of query param
  key/values. The functions with a `!` raise an exception if the 
  API call results in an error. 
    
  ```elixir
      Nba.Stats.player_profile(%{"PlayerID" => 1628366})
      #=> {:ok, ...}

      Nba.Stats.player_profile(%{"PlayerID" => "Go Bruins"})
      #=> {:error, "The value 'Go Bruins' is not valid for PlayerID.; PlayerID is required"}
      
      Nba.Stats.player_profile!(%{"PlayerID" => "Go Bruins"})
      #=> %{"CareerHighs" => ...}
      
      Nba.Stats.player_profile!(%{"PlayerID" => "Go Bruins"})
      #=> ** (RuntimeError) The value 'Go Bruins' is not valid for PlayerID.; PlayerID is required
  ```
