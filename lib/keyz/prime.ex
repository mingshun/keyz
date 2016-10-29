defmodule Keyz.Prime do
  @moduledoc """
  Module to generate random primes.
  """

  use Bitwise

  @doc """
  Generates random prime of the given length in bits.
  """
  def rand_prime(bits) do
    if bits < 2, do: raise "prime size must be at least 2-bit"
    p = rand_integer(bits) |> bor(1) |> next_probably_prime
    case integer_bit_size(p) do
      ^bits -> p
      _     -> rand_prime bits
    end
  end

  defp next_probably_prime(r) do
    case probably_prime(r) do
      true  -> r
      false -> next_probably_prime(r + 2)
    end
  end

  defp integer_bit_size(x) do
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
  Determines whether the given integer n is a prime.
  If x is prime, it returns true. 
  If x is not prime, it returns false with probability at least 1 - ¼ⁿ.
  """
  def probably_prime(n) when n < 2, do: false
  def probably_prime(n) when rem(n, 2) == 0, do: n == 2
  def probably_prime(n) do
    miller_rabin_test n
  end

  @doc """
  Performs t Miller-Rabin tests to check whether n is prime.
  """
  def miller_rabin_test n, t \\ 20
  def miller_rabin_test n, t do
    {d, s} = find_ds n
    as = rand_a(n, t)
    not Enum.any? as, fn a -> fermat_test(a, d, s, n) end
  end

  defp rand_a(n, t) do
    case n - 2 > t do
      true  -> rand_a1 n, t, []
      false -> 2..(n - 1)
    end
  end
  defp rand_a1(_, 0, l), do: l
  defp rand_a1(n, t, l) do
    r = :crypto.rand_uniform 2, n
    case r in l do
      true  -> rand_a1 n, t, l
      false -> rand_a1 n, t - 1, [r | l]
    end
  end

  defp fermat_test(a, d, s, n) do
    x = pow_mod a, d, n
    n1 = n - 1
    case x do
      1   -> false
      ^n1 -> false
      _   -> fermat_test1(x, s - 1, n)
    end
  end
  defp fermat_test1(x, 0, n), do: x != n - 1
  defp fermat_test1(x, s, n) do
    n1 = n - 1
    case x1 = pow_mod(x, 2, n) do
      1   -> true
      ^n1 -> false
      _   -> fermat_test1(x1, s - 1, n)
    end
  end

  defp find_ds(n), do: find_ds1 n - 1, 0
  defp find_ds1(d, s) when rem(d, 2) == 0, do: find_ds1 div(d, 2), (s + 1)
  defp find_ds1(d, s), do: {d, s}

  @doc """
  Calculates modular power.
  """
  def pow_mod(a, p, m) when p > 0 and m > 0 do
    pb = Integer.digits p, 2
    pow_mod1 a, pb, m, 1
  end

  defp pow_mod1 _, [], _, result do result end
  defp pow_mod1 a, pb, m, result do
    [pi | pb1] = pb
    result1 = rem result * result, m
    case pi do
      1 -> pow_mod1 a, pb1, m, rem(result1 * a, m)
      0 -> pow_mod1 a, pb1, m, rem(result1, m)
    end
  end

end