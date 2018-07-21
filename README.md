# ElixirNba

**TODO: Add description**

## Use
`iex -S mix`

Each endpoint has two corresponding functions in the `ElixirNba` module.

Type `ElixirNba.` then tab to see what's available.

The functions with arity of 0 return a list of the endpoint's valid parameters, e.g.

```elixir
iex(1)> ElixirNba.player_info()
PlayerID | SeasonType | LeagueID
:ok
```

To make a call to the endpoint, pass in a `map()` containing param keys and values, e.g.

```elixir
iex(2)> ElixirNba.player_info(%{"PlayerID" => "1627742"})
```
