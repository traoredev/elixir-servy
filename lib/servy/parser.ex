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

    %Conv{method: method, path: path, params: parse_query_string(params_string)}
  end

  def parse_query_string(params_string) do
    params_string |> String.trim() |> URI.decode_query()
  end
end
