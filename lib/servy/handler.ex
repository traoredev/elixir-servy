defmodule Servy.Handler do
  @moduledoc """
  Handle HTTP requests.
  """
  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]
  alias Servy.Parser
  alias Servy.Conv
  alias Servy.BearController

  @pages_path Path.expand("../pages", __DIR__)

  @doc """
    Tranform request into a response
  """
  def handle(request) do
    request
    |> Parser.parse()
    |> rewrite_path()
    |> log()
    |> route()
    |> track()
    |> format_response()
  end

  # Create a new map that also has the response body
  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    %{conv | status: 200, response_body: "Bears, Lions, Tigers"}
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    BearController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    BearController.show(conv, params)
  end

  def route(%Conv{method: "POST", path: "/bears"} = conv) do
    BearController.create(conv, conv.params)
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    @pages_path
    |> Path.join("about.html")
    |> File.read()
    |> handle_file(conv)
  end

  def route(%Conv{path: path} = conv) do
    %{conv | status: 404, response_body: "No #{path} here!"}
  end

  def handle_file({:ok, content}, conv) do
    %{conv | status: 200, response_body: content}
  end

  def handle_file({:error, :enoent}, conv) do
    %{conv | status: 404, response_body: "File not found"}
  end

  def handle_file({:error, reason}, conv) do
    %{conv | status: 500, response_body: "File error #{reason}"}
  end

  # Use values in the map to create an HTTP response string:
  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}\r
    Content-Type: text/html\r
    Content-Length: #{String.length(conv.response_body)}\r
    \r
    #{conv.response_body}
    """
  end
end
