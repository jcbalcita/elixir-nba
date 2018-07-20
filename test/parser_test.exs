defmodule ParserTest do
  use ExUnit.Case
  doctest ElixirNba.Parser
  alias ElixirNba.Parser

  test "can read parameters and endpoints from json file" do
    # when
    parameters = Parser.parameters()
    endpoints = Parser.endpoints()

    # then
    Enum.each(endpoints, fn p ->
      assert Map.has_key?(p, "name") && Map.has_key?(p, "url") && Map.has_key?(p, "parameters")
    end)

    Enum.each(parameters, fn p ->
      assert Map.has_key?(p, "name") && Map.has_key?(p, "default") && Map.has_key?(p, "values")
    end)
  end

  test "creates headers map from json file" do
    # when
    headers = Parser.headers()

    # then
    assert headers["Referer"] == "http://stats.nba.com"
    assert headers["Referrer"] == "http://stats.nba.com"
    assert headers["Origin"] == "http://stats.nba.com"
    assert headers["Accept-Encoding"] == "gzip, deflate"
    assert headers["Accept-Language"] == "en-US"
    assert headers["Accept"] == "*/*"
    assert headers["Connection"] == "keep-alive"
    assert headers["Cache-Control"] == "no-cache"
    assert headers["User-Agent"] ==
             "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:61.0) Gecko/20100101 Firefox/61.0"
  end
end
