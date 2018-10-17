defmodule Nba.StatsTest do
  use ExUnit.Case
  alias Nba.Parser
  doctest Nba.Stats

  Application.put_env(:nba, :http_stats, Nba.FakeHttp.Stats)

  test "creates functions for each endpoint" do
    Parser.Stats.endpoints_by_name()
    |> Map.keys()
    |> Enum.each(fn endpoint_name ->
      apply(Nba.Stats, :"#{endpoint_name}", [%{"dummy_key" => "dummy_value"}])
    end)
  end

  test "param_values_for/1 returns empty list when given an invalid param" do
    # given
    invalid_param = "I'm-so-invalid!"
    # when
    actual = Nba.Stats.param_values_for(invalid_param)
    # then
    assert([] == actual)
  end

  test "param_values_for/1 returns a list of example param values when given a valid param" do
    # given
    expected = ["1996-97", "1997-98", "1998-99", "1999-00", "2000-01", "2001-02", "2002-03",
                "2003-04", "2004-05", "2005-06", "2006-07", "2007-08", "2008-09", "2009-10",
                "2010-11", "2011-12", "2012-13", "2013-14", "2014-15", "2015-16", "2016-17",
                "2017-18", "2018-19"]

    valid_param = "Season"

    # when
    actual = Nba.Stats.param_values_for(valid_param)

    # then
    assert(expected == actual)
  end

end
