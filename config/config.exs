use Mix.Config

config :elixir_nba, :http, ElixirNba.Http

import_config "#{Mix.env()}.exs"
