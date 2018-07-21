defmodule ElixirNba.Http do
  alias ElixirNba.Parser

  @headers Parser.headers()

  def get(url) do
    IO.puts(url)

    case HTTPoison.get(url, @headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body, headers: headers}} ->
        handle_response(body, headers)

      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        IO.puts("Oops! Status code: #{status_code}")
        IO.puts(body)

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.puts("Uh oh! #{reason}")
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
end
