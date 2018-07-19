defmodule ParserTest do
  use ExUnit.Case
  doctest ElixirNba.Parser
  alias ElixirNba.Parser

  test "can read parameters and endpoints from json file" do
    assert Enum.count(Parser.parameters()) == 77
    assert Enum.count(Parser.endpoints()) == 32
  end

  test "creates headers map from json file" do
    # when
    headers = Parser.headers()

    # then
    assert headers["user_agent"] ==
             "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.101 Safari/537.36"

    assert headers["referer"] == "http://stats.nba.com/scores/"
    assert headers["origin"] == "http://stats.nba.com"
  end
end
