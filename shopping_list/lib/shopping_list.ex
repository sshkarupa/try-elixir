defmodule ShoppingList do
  use GenServer

  # Client side
  def start_link(list \\ []) do
    GenServer.start_link(__MODULE__, list)
  end

  def add(pid, item) do
    GenServer.cast(pid, {:add, item})
  end

  def remove(pid, item) do
    GenServer.cast(pid, {:remove, item})
  end

  def view(pid) do
    GenServer.call(pid, :view)
  end

  def stop(pid) do
    GenServer.stop(pid, :normal, :infinity)
  end

  # Server side
  def init(list) do
    {:ok, list}
  end

  def handle_cast({:add, item}, list) do
    updated_list = [item | list]
    {:noreply, updated_list}
  end

  def handle_cast({:remove, item}, list) do
    updated_list = Enum.reject(list, &(&1 == item))
    {:noreply, updated_list}
  end

  def handle_call(:view, _from, list) do
    {:reply, list, list}
  end

  def terminate(_reason, list) do
    IO.puts("We are all done shopping.")
    IO.inspect(list)
    :ok
  end
end
