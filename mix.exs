defmodule Nba.MixProject do
  use Mix.Project

  def project do
    [
      app: :nba,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      package: package(),
      description: description(),
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*", "nba.json"],
      maintainers: ["John Carlo Aspiras Balcita"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/jcbalcita/elixir-nba"}
    ]
  end

  defp description do
    """
    Elixir client for various stats.nba.com API endpoints
    """
  end

  defp elixirc_paths(:test), do: ["lib", "test/fakes"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      env: [http: http_module()]
    ]
  end

  def http_module do
    if Mix.env == :prod, do: Nba.Http, else: Nba.FakeHttp
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poison, "~> 3.1"},
      {:httpoison, "~> 1.0"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end
end
