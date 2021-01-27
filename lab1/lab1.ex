# COMP 4958 Lab 1
# Richard Le A01080411 SET 4V

defmodule Lab1 do
# 1a 
  def join(sep, lst), do: join_helper(sep, lst, [])  
  
  defp join_helper(sep, lst, acc) do 
    case lst do
      [] -> acc
      [t] -> acc ++ [t]
      [h | t] -> join_helper(sep, t, acc ++ [h, sep])
    end 
  end

# 1b
  def flatten(deep_list), do: flatten_helper(deep_list)
  defp flatten_helper([h | t]), do: flatten(h) ++ flatten(t)
  defp flatten_helper([]), do: []
  defp flatten_helper(x), do: [x]

# Helper function for 1c
  defp reverse(l), do: reverse(l, [])
  defp reverse([], l), do: l
  defp reverse([h | t], l), do: reverse(t, [h | l])

# 1c  
  def dedup(lst), do: dedup_helper(lst, [])
  defp dedup_helper([], acc), do: reverse(acc)
  defp dedup_helper([h | t], acc) do
    cond do
      h === List.first(acc) -> dedup_helper(t, acc)
      h !== List.first(acc) -> dedup_helper(t, [h] ++ acc)
    end 
  end


# 2

  def primes(n), do: sieve(Enum.to_list(2..n), [], ceil(:math.sqrt(n)))

  defp sieve(lst, acc, sqrtVal) do 
    case lst do
      [] -> acc
      [h | t] when h <= sqrtVal -> 
        sieve(Enum.filter(t, fn x -> rem(x, h) != 0 end), [h | acc] ,sqrtVal)
      rest -> Enum.reverse(acc) ++ rest
    end
  end
end

IO.puts("Number of primes under 10 million: ")
IO.inspect(length(Lab1.primes(10000000)))

