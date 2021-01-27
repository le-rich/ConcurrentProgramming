# COMP 4958 
# Richard Le - Set 4V - Assignment 1 - A01080411

defmodule A1 do
  def powm(a, n, 0), do: throw(:DivideByZeroException) 
  def powm(a, n, m), do: rem(round(:math.pow(a, n)), m)

  defp gcd(a, 0), do: abs(a)
  defp gcd(a, b), do: gcd(b, rem(a, b))

  def lcm(a, b), do: (a * b) / gcd(a, b) 
  
  def inverse(a, n), do: 1 / (rem(a, n))


  defp base10_to_base256(n, acc) do
    quotient = div(n, 256)
    remainder = rem(n, 256) 
    if (quotient < 256) do
      Integer.to_string(quotient) <> Integer.to_string(remainder) <> acc
    else 
      base10_to_base256(quotient, Integer.to_string(remainder) <>  acc)
    end
  end
  
  def base256_to_base10(n, currDigitPlace, acc) do
    case n do
      [] ->  trunc(acc)

      [h | t] -> 
        baseMult = :math.pow(256, currDigitPlace)
        product = h * baseMult
        base256_to_base10(t, currDigitPlace - 1, acc + product)
    end
  end

  def integer_to_binary(n), do: base10_to_base256(n, "") 

  def binary_to_integer(bin), do: base256_to_base10(String.to_charlist(bin), String.length(bin) - 1, 0)
end
