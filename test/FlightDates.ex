defmodule FlightDatesTest do
  use ExUnit.Case
  doctest FlightDates
  
  test "Generates flight dates" do
    fri = %Calendar.Date{day: 20, month: 5, year: 2016}
    sun = %Calendar.Date{day: 22, month: 5, year: 2016}

    res = FlightDates.next_n(fri,sun,100)
    IO.puts inspect(res)
  end
end

  
