defmodule Nba.StatsTest do
  use ExUnit.Case
  alias Nba.Parser
  doctest Nba.Stats

  test "creates functions for each endpoint (happy path)" do
    # given
    Application.put_env(:nba, :http, Nba.FakeHttp.Stats)

    # then
    Parser.Stats.endpoints_by_name()
    |> Map.keys()
    |> Enum.each(fn endpoint_name ->
      try do
        args_list = [{:test_key_one, "test_value"}, {:test_key_two, "test_value"}]
        {:ok, result} = apply(Nba.Stats, :"#{endpoint_name}", [args_list]) 
        assert is_map(result)
      rescue
        _ -> assert false, "Endpoint #{endpoint_name} failed"
      end
    end)
  end

  test "endpoint function unhappy path" do
    # given
    Application.put_env(:nba, :http, Nba.FakeBadHttp)
    expected_error_msg = "you done messed up"

    # then
    Parser.Stats.endpoints_by_name()
    |> Map.keys()
    |> Enum.each(fn endpoint_name ->
        assert_raise(RuntimeError, expected_error_msg, fn -> apply(Nba.Stats, :"#{endpoint_name}!", []) end)
    end)

    # then
    Parser.Stats.endpoints_by_name()
    |> Map.keys()
    |> Enum.each(fn endpoint_name ->
        {:error, error} = apply(Nba.Stats, :"#{endpoint_name}", [])
        assert error == expected_error_msg
    end)
  end

  test "values_for/1 returns empty list when given an invalid param" do
    # given
    invalid_param = "I'm-so-invalid!"
    # when
    actual = Nba.Stats.values_for(invalid_param)
    # then
    assert([] == actual)
  end

  test "values_for/1 returns a list of example param values when given a valid param" do
    # given
    expected = ["1996-97", "1997-98", "1998-99", "1999-00", "2000-01", "2001-02", "2002-03",
                "2003-04", "2004-05", "2005-06", "2006-07", "2007-08", "2008-09", "2009-10",
                "2010-11", "2011-12", "2012-13", "2013-14", "2014-15", "2015-16", "2016-17",
                "2017-18", "2018-19"]

    valid_param = "Season"

    # when
    actual = Nba.Stats.values_for(valid_param)

    # then
    assert(expected == actual)
  end
end
