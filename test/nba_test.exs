defmodule Nba.NbaTest do
  use ExUnit.Case
  doctest Nba

  test "json_library/0 returns Jason by default" do
    # given
    json_library = Nba.json_library()
    # when
    Application.delete_env(:nba, :json_library)
    # then
    assert Nba.json_library() == Jason
    # finally
    Application.put_env(:nba, :json_library, json_library)
  end

  test "json_library/0 is configurable" do
    # given
    json_library = Nba.json_library()
    # when
    Application.put_env(:nba, :json_library, Poison)
    # then
    assert Nba.json_library() == Poison
    # finally
    Application.put_env(:nba, :json_library, json_library)
  end
end
