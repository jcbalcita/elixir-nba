defmodule Nba.Http do
  @moduledoc false
  require Logger

  def get(url, headers) do
    Logger.info("Fetching – #{url}")

    case HTTPoison.get(url, headers, recv_timeout: 15000, timeout: 15000) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body, headers: response_headers}} ->
        {:ok, handle_response(body, response_headers)}

      {:ok, %HTTPoison.Response{body: body}} ->
        {:error, body}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}

      _ ->
        {:error, "Error calling API"}
    end
  end

  defp handle_response(body, response_headers) do
    maybe_unzip(body, response_headers)
    |> Nba.json_library().decode!()
  end

  defp maybe_unzip(body, headers) do
    gzip? =
      Enum.any?(headers, fn {name, value} ->
        :hackney_bstr.to_lower(name) == "content-encoding" &&
          :hackney_bstr.to_lower(value) == "gzip"
      end)

    if gzip?, do: :zlib.gunzip(body), else: body
  end

  @spec query_string_from_map(map()) :: String.t()
  def query_string_from_map(parameter_map), do: "?" <> URI.encode_query(parameter_map)
end
