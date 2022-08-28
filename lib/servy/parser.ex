defmodule Servy.Parser do
  @moduledoc """
    Parse the request
  """
  alias Servy.Conv
  # Parse the request string into a map
  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %Conv{method: method, path: path}
  end
end
