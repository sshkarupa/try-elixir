defmodule Servy.Handler do
  @moduledoc "Handles HTTP requests"

  alias Servy.{Conv, BearController, VideoCam, Fetcher}

  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]
  import Servy.Parser, only: [parse: 1]

  @pages_path Path.expand("../../pages", __DIR__)

  @doc "Transforns the request into a response"
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    # |> log
    |> route
    |> track
    |> format_response
  end

  def route(%Conv{method: "GET", path: "/sensors"} = conv) do
    pid = Fetcher.async(fn -> Servy.Tracker.get_location("bigfoot") end)

    snapshots =
      ["cam1", "cam2", "cam3"]
      |> Enum.map(&Fetcher.async(fn -> VideoCam.get_snapshot(&1) end))
      |> Enum.map(&Fetcher.get_result/1)

    where_is_bigfoot = Fetcher.get_result(pid)

    %{conv | status: 200, resp_body: inspect {snapshots, where_is_bigfoot}}
  end

  def route(%Conv{method: "GET", path: "/kaboom"} = conv) do
    raise "Kaboom!"
  end

  def route(%Conv{method: "GET", path: "/hibernate/" <> time} = conv) do
    time |> String.to_integer |> :timer.sleep

    %{conv | status: 200, resp_body: "Awake!"}
  end

  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    %{conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  # Bears routes
  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    BearController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/api/bears"} = conv) do
    Servy.Api.BearController.index(conv)
  end


   def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    BearController.show(conv, params)
  end

  def route(%Conv{method: "POST", path: "/bears", params: params} = conv) do
    BearController.create(conv, params)
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    @pages_path
    |> Path.join("about.html")
    |> File.read
    |> handle_file(conv)
  end

  # def route(%{method: "GET", path: "/about"} = conv) do
  #   file =
  #     Path.expand("../../pages", __DIR__)
  #     |> Path.join("about.html")

  #   case File.read(file) do
  #     {:ok, content} ->
  #       %{conv | status: 200, resp_body: content}
  #     {:error, :enoent} ->
  #       %{conv | status: 404, resp_body: "File not found"}
  #     {:error, reason} ->
  #       %{conv | status: 500, resp_body: "File error: #{reason}"}
  #   end
  # end

  def route(%Conv{path: path} = conv) do
    %{conv | status: 404, resp_body: "No route #{path} here!"}
  end

  def handle_file({:ok, content}, %Conv{} = conv) do
    %{conv | status: 200, resp_body: content}
  end

  def handle_file({:error, :enoent}, %Conv{} = conv) do
    %{conv | status: 404, resp_body: "File not found"}
  end

  def handle_file({:error, reason}, %Conv{} = conv) do
    %{conv | status: 500, resp_body: "File error: #{reason}"}
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}\r
    Content-Type: #{conv.resp_content_type}\r
    Content-Length: #{String.length(conv.resp_body)}\r
    \r
    #{conv.resp_body}
    """
  end
end

# Sending requests
# paths = [
  # "/wildthings",
  # "/bears",
  # "/bears/1"
  # "/bigfoot",
  # "/wildlife",
  # "/about"
# ]

# Enum.each(paths, fn(path) ->
#   request = """
#   GET #{path} HTTP/1.1
#   Host: example.com
#   User-Agent: ExampleBrowser/1.0
#   Accept: */*

#   """
#   request
#   |> Servy.Handler.handle
#   |> IO.puts
# end)

# post_request = """
# POST /bears HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*
# Content-Type: application/x-www-form-urlencoded
# Content-Length: 21

# name=Baloo&type=Brown
# """

# post_request
#   |> Servy.Handler.handle
#   |> IO.puts


# post_request = """
# POST /bears HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*
# Content-Type: application/json
# Content-Length: 21

# name=Baloo&type=Polar
# """

# post_request
#   |> Servy.Handler.handle
#   |> IO.puts