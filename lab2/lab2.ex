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

  #1 Helper: Tail Rec Exponentiation Function
  def pow(base, exp), do: pow(base, exp, 1)
  defp pow(_base, 0, acc), do: acc
  defp pow(base, exp, acc), do: pow(base, exp - 1, acc * base)

  #1 Helper: Tail Rec Factorial Function
  def fact(x), do: fact(x, 1)
  defp fact(0, acc), do: acc 
  defp fact(x, acc), do: fact(x-1, acc * x)

  #2 Helper: Generates primes, custom sieve filters out anything less than 1000000
  def primes(n), do: sieve(Enum.to_list(2..n), [], ceil(:math.sqrt(n)))
  defp sieve(lst, acc, sqrtVal) do
    case lst do
      [] -> Enum.filter(acc, fn x -> x > 999_999 end)
      [h | t] when h <= sqrtVal -> 
        sieve(Enum.filter(t, fn x -> rem(x, h) != 0 end), [h | acc], sqrtVal)
      rest -> Enum.filter((Enum.reverse(acc) ++ rest), fn x -> x > 999_999 end)
    end
  end 
  

  #2 Helper: Given a list of primes, 
  #          create a Key Value Tuple that represents the digits in the prime, and the prime
  def getSevPrimePerms(lstPrimes), do: getSevPrimePerms(lstPrimes, [])
  defp getSevPrimePerms([], acc), do: acc
  defp getSevPrimePerms([h | t], acc) do
    digitKey = Enum.sort(Integer.digits(h))
    getSevPrimePerms(t, [{digitKey, [h]}] ++ acc)
  end


  #2 Helper: Gets a map of all seven digit primes, key is sorted digits, value is list of values
  def getLargestSevenPrimePerms(primesLst), do: mapKVP(getSevPrimePerms(primesLst), Map.new()) 
     

  #2 Helper: Iterates through all the key value pairs, and places them in a map
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

  #2: Gets the count of the largest permutation in the map
  def getMaxSevenPrimePerm(permMap), do: Enum.map(permMap, fn {_k, v} -> length(v) end) |> Enum.max()
end

#1b
IO.puts("Approximate value of the sine of 1: ")
firstTen = Enum.take(Lab2.sin_terms(1), 10)
IO.inspect(Enum.reduce(firstTen, fn x, acc -> x + acc end))

#2
IO.puts("Computing Primes...")
primes = Lab2.primes(10000000)
primeMap = Lab2.getLargestSevenPrimePerms(primes)
IO.inspect(Lab2.getMaxSevenPrimePerm(primeMap))


defmodule Mydb do
  def start() do
    Process.register(spawn(fn -> loop(Map.new()) end), :mydb) 
    :ok
  end
    
  def stop() do
    Process.unregister(:mydb)
    :ok
  end

  def store(key, value) do
    send(:mydb, {self(), {key, value}})
    receive do
      msg -> msg
    end
  end
  
  def find(key) do
    send(:mydb, {self(), {:find, key}})
    receive do
      msg -> msg 
    end
  end

  def match(value) do
    send(:mydb, {self(), {:match, value}})
    receive do
      keys -> keys
    end
  end

  def loop(map) do
      receive do
        {sender, {:find, key}} -> 
          if Map.has_key?(map, key) do
            val = Map.get(map,key)
            send(sender, {:ok, val}) 
          else
            send(sender, {:error, :not_found})
          end
        {sender, {:match, value}} ->
            acc = []
            acc = Enum.filter(map, fn {k, v} -> v == value end)
            acc = Enum.unzip(acc) |> elem(0) 
            send(sender, acc)
        {sender, {key, value}} -> 
          map = Map.put(map, key, value) 
          send(sender, :ok)
          loop(map)
        _ -> loop(map)
      end
    loop(map)
  end
end
