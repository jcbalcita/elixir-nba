defmodule Nba.ParserTest do
  use ExUnit.Case
  doctest Nba.Parser
  alias Nba.Parser

   test "can read stats headers from headers json file" do
    # when
    stats_headers = Parser.stats_headers()

    # then
    assert stats_headers["Referer"] == "https://stats.nba.com/scores/"
    assert stats_headers["Referrer"] == "https://stats.nba.com/scores/"
    assert stats_headers["Origin"] == "https://stats.nba.com"
    assert stats_headers["Accept-Encoding"] == "gzip, deflate"
    assert stats_headers["Accept-Language"] == "en-US"
    assert stats_headers["Accept"] == "*/*"
    assert stats_headers["Connection"] == "keep-alive"
    assert stats_headers["Cache-Control"] == "no-cache"

    assert stats_headers["User-Agent"] ==
             "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:61.0) Gecko/20100101 Firefox/61.0"
  end

  test "can read data headers from headers json file" do
    # when
    data_headers = Parser.data_headers()

    # then
    assert data_headers["Referer"] == "https://data.nba.com/"
    assert data_headers["Referrer"] == "https://data.nba.com/"
    assert data_headers["Origin"] == "https://data.nba.com"
    assert data_headers["Accept-Encoding"] == "gzip, deflate"
    assert data_headers["Accept-Language"] == "en-US"
    assert data_headers["Accept"] == "*/*"
    assert data_headers["Connection"] == "keep-alive"
    assert data_headers["Cache-Control"] == "no-cache"

    assert data_headers["User-Agent"] ==
             "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:61.0) Gecko/20100101 Firefox/61.0"
  end

end