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
    assert headers["User-Agent"] ==
             "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:61.0) Gecko/20100101 Firefox/61.0"

    assert headers["Referer"] == "http://stats.nba.com"
    assert headers["Origin"] == "http://stats.nba.com"
  end
end
