defmodule ElixirNbaTest.QueryString do
  use ExUnit.Case
  doctest ElixirNba.QueryString
  alias ElixirNba.QueryString

  test "builds query string from map" do
    # given
    expected = "?foo=bar&hello=world"
    map = %{"hello" => "world", "foo" => "bar"}

    # when
    actual = QueryString.build(map)

    # then
    assert expected == actual
  end
end