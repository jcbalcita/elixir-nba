defmodule Nba.ParserTest do
  use ExUnit.Case
  doctest Nba.Parser
  alias Nba.Parser

  test "can read stats headers from headers json file" do
    # when
    actual = Parser.headers()

    # then
    assert actual["Referer"] == "https://stats.nba.com/scores/"
    assert actual["Referrer"] == "https://stats.nba.com/scores/"
    assert actual["Origin"] == "https://stats.nba.com"
    assert actual["Accept-Encoding"] == "gzip, deflate"
    assert actual["Accept-Language"] == "en-US,en;q=0.9"
    assert actual["Accept"] == "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8"
    assert actual["Connection"] == "keep-alive"
    assert actual["Cache-Control"] == "no-cache"

    assert actual["User-Agent"] ==
             "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.110 Safari/537.36"
  end

end
