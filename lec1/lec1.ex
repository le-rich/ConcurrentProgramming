defmodule Lec1 do
  def add(a, b) do
    a + b
  end

  # using if/else (non-tail recursive)
  def fact1(n) do
    if n == 1 do
      1
    else 
      n * fact(n-1)
    end
  end


  # using cond (non-tail recursive)
  def fact2(n) do
    cond do
      n == 1 -> 1
      n > 1 -> fact2(n-1) * n
      true -> :error
    end
  end

  # using multiple clauses
  def fact(n), do: fact(n, 1)

  defp fact(1, acc), do: acc

  defp fact(n, acc) when n >= 1, do: fact(n - 1, n * acc)


  # reversing a list
  def reverse(l), do: reverse(l, [])

  defp reverse([], l), do: l

  defp reverse([h|t], l), do: reverse(t, [h|l])


  # reversing a list (using 'case' in helper function)
  def reverse2(l), do: reverse2(l, [])

  # using case
  defp reverse2(l1, l2) do
    case l1 do
      [] -> l2
      [h|t] -> reverse2(t, [h|l2])
    end
  end


  # area of different shapes
  def rectangle_area(w, h), do: w * h

  def triangle_area(w, h), do: 0.5 * w * h


  # alternative "interface" for area
  def area({:rectangle, w, h}), do: w * h

  def area({:triangle, w, h}), do: 0.5 * w * h

  def area(_), do: :error
end

defmodule(Crazy, [do: 
  def(fact(n), [do: if(n == 1, [do: 1, else: n * fact(n-1)])])])

Lec1.fact(100)
