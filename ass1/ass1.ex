# COMP 4958 
# Richard Le - Set 4V - Assignment 1 - A01080411

defmodule A1 do
  def powm(a, n, m), do: :binary.decode_unsigned(:crypto.mod_pow(a, n, m))

  defp gcd(a, 0), do: abs(a)
  defp gcd(a, b), do: gcd(b, rem(a, b))

  def lcm(a, b), do: div(a * b, gcd(a, b))

  defp inverse_helper(a, n), do: inverse_helper(abs(a), abs(n), 0, 1, 1, 0)
  defp inverse_helper(0, last_rem, last_x, last_y, _x, _y), do: {last_rem, last_x} 
  defp inverse_helper(r, last_rem, last_x, last_y, x, y) do
    quotient = div(last_rem, r)
    r2 = rem(last_rem, r)
    inverse_helper(r2, r, x, y, last_x - quotient * x, last_y - quotient * y) 
  end

  def inverse(a, n) do
    case inverse_helper(a, n) do
      {1, x} -> rem(x + n, n)
      _ -> IO.puts("a is not reversible")
    end
  end 
  
  def base10_to_base256(n, acc) do
    quotient = div(n, 256)
    remainder = rem(n, 256) 
    if (quotient < 256) do
      <<quotient>> <> <<remainder>> <> acc
    else 
      base10_to_base256(quotient, <<remainder>> <> acc)
    end
  end
  
  defp pow(base, exp), do: pow(base, exp, 1)
  defp pow(base, 0, acc), do: acc
  defp pow(base, exp, acc), do: pow(base, exp - 1, acc * base)
 
  def base256_to_base10(n, currDigitPlace, acc) do
    case n do
      [] ->  trunc(acc)
      [h | t] -> 
        baseMult = pow(256, currDigitPlace)
        product = h * baseMult
        base256_to_base10(t, currDigitPlace - 1, acc + product)
    end
  end

  def integer_to_binary(n), do: base10_to_base256(n, <<>>) 
  def binary_to_integer(bin), do: base256_to_base10(:binary.bin_to_list(bin), byte_size(bin) - 1, 0)

  def p(), do: 12945845173329038168894514532852761087184861453819103626524746458007544079436193033296354255392833659165781825320450882527971501424543610656635242495207243
  def q(), do: 11651088227042719432197879712448441990940913399774434709130882531920046670720814447752206963062868458438310623799329703497031760471331490496164292198579167
  def e(), do: 65537 
  def n, do: p * q
  def ciphertext, do: <<135,231,178,227,7,91,232,141,250,177,184,224,57,35,133,47,165,77,104,96,112,96,156,153,10,80,90,162,96,105,234,24,7,177,56,175,13,60,93,177,99,243,191,169,155,140,53,92,243,81,58,213,7,204,4,146,50,169,14,194,113,66,85,81,224,87,253,200,100,40,127,31,25,83,76,153,102,163,15,177,235,219,235,34,158,132,30,121,202,1,255,0,53,123,252,73,174,44,189,124,234,168,25,6,184,183,92,180,120,126,117,101,125,81,175,136,40,193,59,185,59,76,0,157,63,11,254,229>>
  def l, do: lcm(p - 1, q - 1)
  def d, do: A1.inverse(e, l) 

  def crypt(text, {k, n}) do
    l = lcm(p - 1, q - 1)
    n = p * q
    d = inverse(e, l)
    intVal = binary_to_integer(text)

    if k == e do
      powm(intVal, k, n) |> integer_to_binary() 
    end
    if k == d do 
      powm(intVal, d, n) |> integer_to_binary()
    end
  end
end


IO.puts("Testing Decrypt: ")
decryptResult = A1.crypt(A1.ciphertext, {A1.d, A1.n})
IO.inspect(decryptResult)
