defmodule Servy.PledgeServerHandRolled do
  alias Servy.GenericServer

  @name :pledge_server

  # Client interface
  def start do
    IO.puts "Starting the pledge hand rolled server..."
    GenericServer.start(__MODULE__, [], @name)
  end

  def create_pledge(name, amount) do
    GenericServer.call(@name, {:create_pledge, name, amount})
  end

  def recent_pledges do
    GenericServer.call(@name, :recent_pledges)
  end

  def total_pledged do
    GenericServer.call(@name, :total_pledged)
  end

  def clear do
    GenericServer.cast(@name, :clear)
  end

  # Callbacks
  def handle_cast(:clear, _state) do
    []
  end

  def handle_call(:recent_pledges, state) do
    {state, state}
  end

  def handle_call(:total_pledged, state) do
    total = Enum.map(state, &elem(&1, 1)) |> Enum.sum
    {total, state}
  end

  def handle_call({:create_pledge, name, amount}, state) do
    {:ok, id} = send_pledge_to_service(name, amount)
    most_recent_pleges = Enum.take(state, 2)
    new_state = [{name, amount} | most_recent_pleges]
    {id, new_state}
  end

  defp send_pledge_to_service(_name, _amount) do
    # Simulate of an external service
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end
end

# alias Servy.PledgeServerHandRolled

# pid = PledgeServerHandRolled.start

# send pid, {:stop, "hammertime"}

# IO.inspect PledgeServerHandRolled.create_pledge("larry", 10)
# IO.inspect PledgeServerHandRolled.create_pledge("moe", 20)
# IO.inspect PledgeServerHandRolled.create_pledge("curly", 30)
# IO.inspect PledgeServerHandRolled.create_pledge("daisy", 40)

# IO.inspect PledgeServerHandRolled.recent_pledges()
# IO.inspect PledgeServerHandRolled.total_pledged()

# PledgeServerHandRolled.clear()

# IO.inspect PledgeServerHandRolled.create_pledge("grace", 50)

# IO.inspect Process.info(pid, :messages)
