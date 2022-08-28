defmodule HandlerTest do
  use ExUnit.Case

  import Servy.Handler, only: [handle: 1]

  test "GET /wildthings" do
    request = """
    GET /wildthings HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)
    # IO.puts(response)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 20\r
    \r
    Bears, Lions, Tigers
    """

    assert response == expected_response
  end

  test "GET /bigfott" do
    request = """
    GET /bigfott HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 404 Not Found\r
    Content-Type: text/html\r
    Content-Length: 17\r
    \r
    No /bigfott here!
    """

    assert response == expected_response
  end

  test "GET /about" do
    request = """
    GET /about HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 330\r
    \r
    <h1>Heart Pirates</h1>

    <blockquote>
    Lorem ipsum dolor sit amet, consectetur adipiscing elit,
    sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
    Lacinia quis vel eros donec ac odio tempor orci. Porta lorem mollis aliquam ut.
    Ut tortor pretium viverra suspendisse potenti nullam ac.
    -- Trafalgar Law
    </blockquote>
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "POST /bears" do
    request = """
    POST /bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    Content-type: application/x-www-form-urlencoded\r
    Content-length: 21\r
    \r
    name=Baloo&type=Brown
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 32\r
    \r
    Created a Brown bear named Baloo
    """

    assert response == expected_response
  end

  test "GET /bears" do
    request = """
    GET /bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 355\r
    \r
    <h1>All bears!</h1>

    <ul>

      <li>Brutus - Grizzly</li>

      <li>Iceman - Polar</li>

      <li>Kenai - Grizzly</li>

      <li>Paddington - Brown</li>

      <li>Roscoe - Panda</li>

      <li>Rosie - Black</li>

      <li>Scarface - Grizzly</li>

      <li>Smokey - Black</li>

      <li>Snow - Polar</li>

      <li>Teddy - Brown</li>

    </ul>

    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /bears/1" do
    request = """
    GET /bears/1 HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 71\r
    \r
    <h1>Show bear</h1>

    <p>Is Teddy hibernating? <strong>true</strong></p>

    """

    assert response == expected_response
  end

  defp remove_whitespace(text) do
    String.replace(text, ~r{\s}, "")
  end
end
