defmodule Nba.Json do
  @json Application.get_env(:nba, :json, Jason)

  def encode(s), do: @json.encode(s)

  def encode!(s), do: @json.encode!(s)

  def decode(s), do: @json.decode(s)

  def decode!(s), do: @json.decode!(s)
end