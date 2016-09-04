defmodule TakeMeHome.Scheduler do
  use GenServer
  require Logger

  def start_link(state) do
    GenServer.start_link(__MODULE__,  state, name: __MODULE__)
  end

  def init({to, from, interval} = state) do
    {:ok, state, interval}
  end

	def trigger do
		send(Process.whereis(TakeMeHome.Scheduler), :timeout)
	end

  def handle_info(:timeout, {to, from, interval} = state) do
    Logger.debug("Checking flights from #{from} to #{to}")


		#TODO Clean up. Very messy
		friday = TakeMeHome.Date.upcoming(:friday)
		sunday = TakeMeHome.Date.next(friday, :sunday)

    flights = lookup_flights({to, from,
															friday, sunday},[],10)
    
    Logger.debug("Found #{inspect(flights)}")
    TakeMeHome.EmailClient.send_email(flights_to_html(flights))
    {:noreply, state, interval}
  end

  def lookup_flights(_, results, 0) do
    results
  end
  
  def lookup_flights({to, from, depart, return}, results, limit) do
    response = TakeMeHome.SkyScanner.search(
      country: "UK",
      from: from,
      to: to,
      depart: Calendar.Date.to_s(depart),
      return: Calendar.Date.to_s(return))

    lookup_flights({to,from,
		    TakeMeHome.Date.next(depart, :friday),
		    TakeMeHome.Date.next(return, :sunday)},
                    response ++ results, limit-1)
  end

  defp flights_to_html(flights) do
    Enum.reduce(flights, "", fn(f, acc) ->
      """
      Price: #{inspect(f.price)}
      Depart: #{inspect(f.depart)} with #{inspect(f.depart[:depart_carrier])}
      Return: #{inspect(f.return)} with #{inspect(f.return[:return_carrier])}

      """ <> acc end)
  end

	defp flights_to_string(flights) do
    Enum.reduce(flights, "", fn(f, acc) ->
      """
      Price: #{f.price}\n
      Depart: #{f.depart}\n 
      Return: #{f.return}\n
      """ <> acc end)
  end
  
end

