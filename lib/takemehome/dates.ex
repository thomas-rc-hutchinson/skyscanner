defmodule TakeMeHome.Date do
  def upcoming(day) when is_atom(day) do
    day = String.to_atom(Atom.to_string(day) <> "?")
    upcoming(Calendar.Date.today_utc, day)  
  end
  
  defp upcoming(date, day) do
    case apply(Elixir.Calendar.Date, day, [date]) do
      true ->
	date
      false ->
	upcoming(Calendar.Date.next_day!(date), day)
    end
  end

  def next(date, day) do
    day = String.to_atom(Atom.to_string(day) <> "?")
    upcoming(Calendar.Date.next_day!(date), day)
  end
  
end
