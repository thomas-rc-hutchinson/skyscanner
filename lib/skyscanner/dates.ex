defmodule FlightDates do

  def next_n(_,_,0) do
    0
  end

  def next_n(start,finish,n) do
    [{start,finish}] ++ next_n(add(start,7),add(finish,7),n-1)
  end

  def add(date,days) do
    {:ok, date} = Calendar.Date.add(date,days)
    date
  end

  def upcoming_saturday(date) do
    case Calendar.Date.saturday?(date) do
      true ->
	date
      false ->
	Calendar.Date.next_day!(date)
    end
  end

  def upcoming_sunday(date) do
    case Calendar.Date.sunday?(date) do
      true ->
	date
      false ->
	Calendar.Date.next_day!(date)
    end
  end
  
  
end
