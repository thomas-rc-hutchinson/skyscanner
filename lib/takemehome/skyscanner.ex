defmodule SkyScanner do
  require Logger
  
  @api_key Application.get_env(:take_me_home, :api_key)

  def search(criteria) do
    Logger.debug("in SkyScanner.search")
    apiKey = @api_key
    url = "http://partners.api.skyscanner.net/apiservices/pricing/v1.0"
    form = {:form,
	    [country: criteria[:country],
	     currency: "GBP",
	     locale: "en-GG",
	     originplace: criteria[:from],
	     destinationplace: criteria[:to],
	     outbounddate: criteria[:depart],
	     inbounddate: criteria[:return],
	     adults: "1",
	     apiKey: apiKey]}

    headers = %{
      "Content-Type" => "application/x-www-form-urlencoded",
      "Accept" => "application/json"
    }

    {:ok, resp} = HTTPoison.post(url,form,headers)
    pricing_url = :proplists.get_value("Location", resp.headers)
    pricing_url = pricing_url <> "?apiKey=#{apiKey}&stops=0"

    headers = %{
      "Accept" => "application/json"
    }

    Logger.debug("session url=#{pricing_url}")
    :timer.sleep 20000 #wait required before checking
    
    {:ok, resp2} = HTTPoison.get(pricing_url, headers)
    parse_response(resp2.body)
  end

  def parse_response(json) do
    data = Poison.decode!(json)
    itineries = data["Itineraries"]
    Enum.map(itineries, fn(it) ->
      from = lookup(:from, it, data)
      to = lookup(:to, it, data)
      depart = lookup(:depart, it, data)
      return = lookup(:return, it, data)
      price = lookup(:price, it, data)
      depart_arival = lookup(:depart_arrival, it, data)
      return_arival = lookup(:return_arrival, it, data)
      depart_carrier = lookup(:depart_carrier, it, data)
      return_carrier = lookup(:return_carrier, it, data)
      
      %SearchResult{from: from, to: to,
		    depart: [depart: depart,
			     depart_arrival: depart_arival,
			     depart_carrier: depart_carrier],
		    return: [return: return,
			     return_arrival: return_arival,
			     return_carrier: return_carrier],
		    price: price}
      end)
  end

  def lookup(:return_carrier, itinery, results) do
    inboundlegid = itinery["InboundLegId"]
    legs = results["Legs"]
    [flight] = from_leg(results, "Id", inboundlegid)["FlightNumbers"]
    
    carrierid = flight["CarrierId"]
    Enum.find(results["Carriers"], fn(carrier) ->
      carrier["Id"] == carrierid end)["Name"]
  end
  
  def lookup(:depart_carrier, itinery, results) do
    outboundlegid = itinery["OutboundLegId"]
    [flight] = from_leg(results, "Id", outboundlegid)["FlightNumbers"]
    
    carrierid = flight["CarrierId"]
    Enum.find(results["Carriers"], fn(carrier) ->
      carrier["Id"] == carrierid end)["Name"]
  end
  
	
  def lookup(:return_arrival, itinery, results) do
    inboundlegid = itinery["InboundLegId"]
    from_leg(results, "Id", inboundlegid)["Arrival"]
  end
  
  def lookup(:depart_arrival, itinery, results) do
    outboundlegid = itinery["OutboundLegId"]
    from_leg(results, "Id", outboundlegid)["Arrival"]
  end
  
  def lookup(:price, itinery, results) do
    pricings = itinery["PricingOptions"]
    price = Enum.map(pricings, fn(price) ->
      price["Price"]
    end) |> Enum.min
  end
  
  def lookup(:return, itinery, results) do
    inboundlegid = itinery["InboundLegId"]
    from_leg(results, "Id", inboundlegid)["Departure"]
  end
  
  def lookup(:depart, itinery, results) do
    outboundlegid = itinery["OutboundLegId"]
    from_leg(results, "Id", outboundlegid)["Departure"]
  end
  
  def lookup(:from, itinery, results) do
    outboundlegid = itinery["OutboundLegId"]
    originstationid = from_leg(results, "Id", outboundlegid)["OriginStation"]
    
    places = results["Places"]
    Enum.find(places, fn(place) ->
      id = place["Id"]
      id == originstationid end)["Name"]
  end

  def lookup(:to, itinery, results) do
    inboundlegid = itinery["InboundLegId"]
    originstationid = from_leg(results, "Id", inboundlegid)["OriginStation"]
    
    places = results["Places"]
    Enum.find(places, fn(place) ->
      id = place["Id"]
      id == originstationid end)["Name"]
  end

  def from_leg(results, key, value) do
    Enum.find(results["Legs"], fn(leg) ->
      leg[key] == value end)
  end
  
end
