defmodule TakeMeHome.Scheduler do
  use GenServer
  require Logger

  def start_link(state) do
    GenServer.start_link(__MODULE__,  state, name: __MODULE__)
  end

  def init({to, from, interval} = state) do
    {:ok, state, interval}
  end

  def handle_info(:timeout, {to, from, interval} = state) do
    Logger.debug("Checking flights...")
    
    flights = lookup_flights({to, from,
			      TakeMeHome.Date.upcoming(:friday),
			      TakeMeHome.Date.upcoming(:sunday)},[],10)
    
    Logger.debug("Found #{inspect(flights)}")
    EmailDispatcher.send_email(flights_to_html(flights))
    {:noreply, state, interval}
  end

  def lookup_flights(_, results, 0) do
    results
  end
  
  def lookup_flight({to, from, depart, return}, results, limit) do
    response = SkyScanner.search(
      country: "UK",
      from: from,
      to: to,
      depart: Calendar.Date.to_s(depart),
      return: Calendar.Date.to_s(return))

    lookup_flights({to,from,
		    TakeMeHome.Date.next(depart, :saturday),
		    TakeMeHome.Date.next(return, :sunday)},
                    [response|results], limit-1)
  end

  def flights_to_html(flights) do
    Enum.reduce(flights, "", fn(f, acc) ->
      """
      Price: #{f.price}</br>
      Depart: #{f.depart}</br> 
      Return: #{f.return}</br></br>
      """ <> acc end)
  end
  
end

