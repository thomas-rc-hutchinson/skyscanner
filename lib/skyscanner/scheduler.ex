defmodule Scheduler do
  use GenServer
  require Logger

  def test, do: start_link({"MAN-Sky","STOC-Sky",1000})
  
  def start_link(state) do
    GenServer.start_link(__MODULE__,  state)
  end

  def init({to, from, interval} = state) do
    {:ok, state, interval}
  end

  def handle_info(:timeout, {to, from, interval} = state) do
    Logger.debug("Checking flights...")

    response = SkyScanner.search(
      country: "UK",
      from: from,
      to: to,
      depart: "2016-06-24",
      return: "2016-06-26")

    Logger.debug("Found #{inspect(response)}")
    #flights less than 150 GBP
    flights = response |> Enum.filter(fn(it) -> it.price <= 150 end)
    EmailServer.send_email(inspect(response))
    {:noreply, state, interval}
  end  
end

