use Mix.Config

config :nba, :http, Nba.Http

import_config "#{Mix.env()}.exs"
