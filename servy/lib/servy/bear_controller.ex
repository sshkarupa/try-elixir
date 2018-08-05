defmodule Servy.BearController do
  alias Servy.{Bear, Wildthings}

  @templates_path Path.expand("../../templates", __DIR__)

  def index(conv) do
    bears =
      Wildthings.list_bears
      |> Enum.sort(&Bear.order_asc_by_name/2)
    render(conv, "index.html.eex", bears: bears)
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)
    render(conv, "show.html.eex", bear: bear)
  end

  def create(conv, %{"name" => name, "type" => type} = params) do
    %{conv | status: 201,
             resp_body: "Created a #{type} bear named #{name}!"}
  end

  defp render(conv, template, binding \\ []) do
    content =
      @templates_path
      |> Path.join(template)
      |> EEx.eval_file(binding)

    %{conv | status: 200, resp_body: content}
  end
end
