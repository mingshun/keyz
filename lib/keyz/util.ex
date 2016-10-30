defmodule Keyz.Util do
  @moduledoc """
  Module to provide utilities for library usage.
  """

  @doc """
  Calculates the bit size of the given integer.
  """
  def integer_bit_size(x) do
    bitstr = :binary.encode_unsigned x
    <<first_byte :: size(8), _ :: bitstring>> = bitstr
    f = case :binary.encode_unsigned(first_byte) do
      <<1 :: size(1), _ :: bitstring>> -> 8
      <<1 :: size(2), _ :: bitstring>> -> 7
      <<1 :: size(3), _ :: bitstring>> -> 6
      <<1 :: size(4), _ :: bitstring>> -> 5
      <<1 :: size(5), _ :: bitstring>> -> 4
      <<1 :: size(6), _ :: bitstring>> -> 3
      <<1 :: size(7), _ :: bitstring>> -> 2
      <<1 :: size(8), _ :: bitstring>> -> 1
    end
    bit_size(bitstr) - (8 - f)
  end

  @doc """
  Computes GCD of the given x and y.
  """
  def gcd(x, 0), do: x
  def gcd(x, y), do: gcd y, rem(x, y)

  def extended_gcd(a, b) do
    {last_remainder, last_x} = extended_gcd(abs(a), abs(b), 1, 0, 0, 1)
    {last_remainder, last_x * (if a < 0, do: -1, else: 1)}
  end
 
  defp extended_gcd(last_remainder, 0, last_x, _, _, _), do: {last_remainder, last_x}
  defp extended_gcd(last_remainder, remainder, last_x, x, last_y, y) do
    quotient   = div(last_remainder, remainder)
    remainder2 = rem(last_remainder, remainder)
    extended_gcd(remainder, remainder2, x, last_x - quotient*x, y, last_y - quotient*y)
  end
 
  @doc """
  Computes the inverse of e modulo et
  """
  def mod_inverse(e, et) do
    {g, x} = extended_gcd(e, et)
    if g != 1, do: raise "The maths are broken!"
    rem(x+et, et)
  end

end