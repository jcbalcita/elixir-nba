defmodule Nba.MixProject do
  use Mix.Project

  def project do
    [
      app: :nba,
      version: "0.8.2",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      package: package(),
      description: description(),
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  defp package do
    [
      files: [
        "lib",
        "mix.exs",
        "README*",
        "LICENSE*",
        "data"
      ],
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
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.5"},
      {:jason, "~> 1.1", optional: true},
      {:ex_doc, "~> 0.19", only: [:dev]},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:poison, "~> 4.0", only: [:test]}
    ]
  end
end
