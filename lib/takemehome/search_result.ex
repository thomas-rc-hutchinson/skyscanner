defmodule TakeMeHome.SearchResult do
  defstruct from: "", to: "", depart: [], return: [], price: ""

  def less_than_price(results, price) do
    Enum.filter(results, fn(r) ->
      r.price < price
      end)
  end
end
