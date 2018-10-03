defmodule Nba.Http do
  @moduledoc false
  alias Nba.Parser

  def get(url, headers) do
    IO.puts("Fetching – #{url}\n")

    case HTTPoison.get(url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body, headers: response_headers}} ->
        {:ok, handle_response(body, response_headers)}

      {:ok, %HTTPoison.Response{body: body}} ->
        {:error, body}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp handle_response(body, headers) do
    maybe_unzip(body, headers)
    |> Poison.decode!()
  end

  defp maybe_unzip(body, headers) do
    gzip? =
      Enum.any?(headers, fn {name, value} ->
        :hackney_bstr.to_lower(name) == "content-encoding" &&
          :hackney_bstr.to_lower(value) == "gzip"
      end)

    body = if gzip?, do: :zlib.gunzip(body), else: body

    body
  end

  defmodule Stats do
    @headers Parser.stats_headers()

    def get(url), do: Nba.Http.get(url, @headers)
  end

  defmodule Data do
    @headers Parser.data_headers()

    def get(url), do: Nba.Http.get(url, @headers)
  end
end
