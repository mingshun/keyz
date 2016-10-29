defmodule Keyz.Prime do
  @moduledoc """
  Module to generate random primes.
  """

  # Small primes for test.
  @small_primes [2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97]

  @doc """
  Fermat prime test. Default base is 2.
  """
  def fermat_test p, a \\ 2
  def fermat_test(1, _), do: false
  def fermat_test(2, _), do: true
  def fermat_test(p, a) when p > 2 and a > 1 do
    Keyz.Math.mod_pow(a, p - 1, p) == 1
  end

  @doc """
  Performs t Miller-Rabin tests to check whether n is prime.
  """
  def probably_prime n, t \\ 20
  def probably_prime(_, t) when t < 0, do: raise "non-positive n for probably_prime"
  def probably_prime(n, _) when n < 2, do: false
  def probably_prime(n, _) when (rem n, 2) == 0, do: n == 2
  def probably_prime(n, _) when n < 100, do: Enum.member? @small_primes, n
  def probably_prime n, t do
    resolve_d = fn
      x when rem x, 2 == 0 -> div x, 2
      x                    -> x
    end
    d = resolve_d.(n - 1)

  end
  
  @doc """
  Generates random integer of the given length in bits.
  """
  def rand_integer(bits) when bits > 0 do
    bytes = div bits + 7, 8
    r = :crypto.strong_rand_bytes bytes
    b = 
      case b1 = rem bits, 8 do
        0 -> 8
        _ -> b1
      end
    f = 8 - b + 1
    <<_ :: size(f), rest :: bitstring>> = r
    << 1 :: size(f), rest :: bitstring>> |> :crypto.bytes_to_integer
  end

  @doc """
  Generates random prime of the given length in bits.
  """
  def rand_prime(bits) do
    if bits < 2, do: raise "prime size must be at least 2-bit"
    r = rand_integer bits
    b = 
      case b1 = rem bits, 8 do
        0 -> 8
        _ -> b1
      end
    f = 8 - b + 2
    <<_ :: size(f), rest :: bitstring>> = r
    r = <<0b11 :: size(f), rest :: bitstring>>
    f = bits - 1
    <<rest :: size(f), _ :: size(1)>> = r
    r = <<rest :: size(f), 1 :: size(1)>>
    if probably_prime(r, 20), do: r, else: rand_prime bits
  end

end