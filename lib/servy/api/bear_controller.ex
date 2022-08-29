defmodule Servy.Api.BearController do
  alias Servy.Wildthings

  def index(conv) do
    json =
      Wildthings.list_bears()
      |> Jason.encode!()

    response_headers = %{conv.response_headers | content_type: "application/json"}

    %{
      conv
      | status: 200,
        response_headers: response_headers,
        response_body: json
    }
  end
end
