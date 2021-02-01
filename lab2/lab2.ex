# COMP 4958 - Lab 3
# Richard Le A01080411 Set 4V


defmodule Lab2 do
# 1a
  def sin_terms(x) do
    odds = Stream.iterate(1, fn(x) -> x + 2 end)
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

  def primes(n), do: sieve(Enum.to_list(2..n), [], ceil(:math.sqrt(n)))
  defp sieve(lst, acc, sqrtVal) do
    case lst do
      [] -> Enum.filter(acc, fn x -> x > 999_999 end)
      [h | t] when h <= sqrtVal -> 
        sieve(Enum.filter(t, fn x -> rem(x, h) != 0 end), [h | acc], sqrtVal)
      rest -> Enum.filter((Enum.reverse(acc) ++ rest), fn x -> x > 999_999 end)
    end
  end 
  

  def getSevPrimePerms(lstPrimes), do: getSevPrimePerms(lstPrimes, [])
  defp getSevPrimePerms([], acc), do: acc
  defp getSevPrimePerms([h | t], acc) do
    digitKey = Enum.sort(Integer.digits(h))
    getSevPrimePerms(t, [{digitKey, [h]}] ++ acc)
  end

  def getLargestSevenPrimePerms(primesLst), do: mapKVP(getSevPrimePerms(primesLst), Map.new()) 
     
  def getMaxSevenPrimePerm(permMap), do: Enum.map(permMap, fn {_k, v} -> length(v) end) |> Enum.max()

  def mapKVP(kvps, map) do
    case kvps do
      [] -> map
      [{k, v} | t] -> 
      if Map.has_key?(map, k) do
        mapKVP(t, Map.get_and_update(map, k, fn x -> {x, x ++ v} end) |> elem(1)) 
      else
        mapKVP(t, Map.put(map, k, v))
      end
    end
  end
 
  def findKeyOrMakeNew(k, v, acc) do
    case acc do
      [] -> [{k, [v]}] ++ acc
      [{headKey, headVal} | t] -> 
        if headKey == k do 
          [{headKey, [v] ++ headVal}] ++ acc
        else
          [{headKey, headVal}] ++ findKeyOrMakeNew(k, v, t)
        end
    end 
  end 
   


end

#1b
IO.puts("Approximate value of the sine of 1: ")
firstTen = Enum.take(Lab2.sin_terms(1), 10)
IO.inspect(Enum.reduce(firstTen, fn x, acc -> x + acc end))

