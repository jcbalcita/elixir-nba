# ElixirNba
https://hex.pm/packages/nba/

  Elixir implementation of bttmly/nba-client-template

  stats.nba.com uses a large number of undocumented JSON endpoints
  to provide the statistics tables and charts displayed therein.
  This library provides an Elixir client for interacting with many
  of those API endpoints.

  ## Examples
  See what endpoints you can hit:

      Nba.endpoints()
      #=> [:assist_tracker, :box_score, :player_info, ...]

  Each endpoint has two corresponding functions, one with an
  arity of 0 and one with an arity of 1. The 0-arity functions
  return a list of the available query parameters for
  its endpoint.

      Nba.player_info()
      #=> ["PlayerID", "SeasonType", "LeagueID"]

  Now that you know what query params you can pass, let's make
  a call to the endpoint by passing in a map of query param
  key/values.

      Nba.player_info(%{"PlayerID" => "1627742"})

  If you need example values for a query param, use `ElixirNba.param_values_for/1`.

      Nba.param_values_for("AheadBehind")
      #=> ["Ahead or Behind", "Ahead or Tied", "Behind or Tied", ""]

