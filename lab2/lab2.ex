# COMP 4958 - Lab 3
# Richard Le A01080411 Set 4V


defmodule Lab2 do
# 1a
  def sin_terms(x) do
    odds = Stream.iterate(1, fn(x) -> x + 1 end)
    odds = Stream.filter(odds, fn(x) -> rem(x, 2) != 0 end)
    inversePowOdds = Stream.map(odds, fn(y) -> pow(x, y) / fact(y) end) 
    inverseNeg = Stream.map(inversePowOdds, fn(x) -> -x end) 
    inverseNeg = Stream.map_every(inverseNeg, 2, fn(x) -> -x end)
    inverseNeg
  end

  def pow(base, exp), do: pow(base, exp, 1)
  defp pow(_base, 0, acc), do: acc
  defp pow(base, exp, acc), do: pow(base, exp - 1, acc * base)

  def fact(x), do: fact(x, 1)
  defp fact(0, acc), do: acc 
  defp fact(x, acc), do: fact(x-1, acc * x)
end

#1b
IO.puts("Approximate value of the sine of 1: ")
firstTen = Enum.take(Lab2.sin_terms(1), 10)
IO.inspect(Enum.reduce(firstTen, fn x, acc -> x + acc end))

