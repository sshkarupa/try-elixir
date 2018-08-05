defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse
    |> route
    |> format_response
  end

  def parse(conv) do
    # TODO: Parse the resuest string into map:
    conv = %{method: "GET", path: "/wildthings", resp_body: ""}
  end

  def route(conv) do
    # TODO: Create a new map that also has th response body:
    conv = %{method: "GET", path: "/wildthings", resp_body: ""}
  end

  def format_response(conv) do
    # TODO: Use values in the map to creare an HTTP response string
    """
    HTTP/1.1 200 OK
    Cntent-Type: text/html
    Content-Lenght: 20

    Bears, Lions, Tigers
    """
  end
end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response