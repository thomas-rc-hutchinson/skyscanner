defmodule SkyscannerTest do
  use ExUnit.Case
  doctest SkyScanner

 # test "Search for flights from Stockholm to Manchester" do
  #  response = SkyScanner.search(
   #   country: "UK",
    #  from: "STOC-Sky",
     # to: "MAN-Sky",
   #   fromdate: "2016-05-20",
   #   todate: "2016-05-25")

  #  IO.puts("response=#{inspect response}")
  #end

  test "Parses the flight results" do
    {:ok, json} = :file.read_file("sky_flights.json")
    res = SkyScanner.parse_response(json)
    IO.puts inspect(res)
  end
  
end
