defmodule Nba.Http.QueryStringTest do
  use ExUnit.Case
  doctest Nba.Http.QueryString
  alias Nba.Http.QueryString

  test "builds query string from map" do
    # given
    expected = "?empty=&foo=bar&hello=world"
    map = %{"hello" => "world", "foo" => "bar", "empty" => ""}

    # when
    actual = QueryString.build(map)

    # then
    assert expected == actual
  end
end
