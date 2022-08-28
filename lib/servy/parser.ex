defmodule Servy.Parser do
  @moduledoc """
    Parse the request
  """
  alias Servy.Conv
  # Parse the request string into a map
  def parse(request) do
    [top, params_string] = String.split(request, "\n\n")
    [request_line | headers_lines] = String.split(top, "\n")
    [method, path, _] = String.split(request_line, " ")

    headers = parse_headers(headers_lines, %{})
    params = parse_params(headers["Content-type"], params_string)

    %Conv{method: method, path: path, params: params, headers: headers}
  end

  def parse_headers([head | tail], headers) do
    [key, value] = String.split(head, ": ")
    headers = Map.put(headers, key, value)
    parse_headers(tail, headers)
  end

  def parse_headers([], headers), do: headers

  def parse_params("application/x-www-form-urlencoded", params_string) do
    params_string |> String.trim() |> URI.decode_query()
  end

  def parse_params(_, _), do: %{}
end
