defmodule Keyz.Prime do
  @moduledoc """
  Module to generate random primes.
  """

  use Bitwise
  alias Keyz.Util

  # Small primes used to rapidly exclude some fraction of composite candidates.
  @small_primes [3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53]
  @small_primes_product Enum.reduce @small_primes, &(*/2)

  @doc """
  Generates a random prime of the given length in bits according to n Miller-Rabin tests.
  """
  @spec rand_prime(pos_integer) :: pos_integer
  @spec rand_prime(pos_integer, pos_integer) :: pos_integer
  def rand_prime bits, n \\ 20
  def rand_prime(bits, n) do
    if bits < 2, do: raise "prime size must be at least 2-bit"
    p = rand_integer(bits) |> bor(1) |> next_probably_prime(bits, n)
    case Util.integer_bit_size(p) do
      ^bits -> p
      _     -> rand_prime bits
    end
  end

  defp next_probably_prime(r, bits, n) do
    case probably_prime(r, n) do
      true  -> r
      false -> next_probably_prime(r + next_delta(r, bits), bits, n)
    end
  end

  defp next_delta(r, bits) do
    if bits > 6 do
      mod = rem r, @small_primes_product
      next_delta1 mod, 2
    else
      2
    end
  end
  defp next_delta1(_, 1048576), do: 1048576  # 1 <<< 20
  defp next_delta1(mod, delta) do
    m = mod + delta
    skip = Enum.any? @small_primes, fn 
      prime -> rem(m, prime) == 0 and  m != prime
    end
    case skip do
      true  -> next_delta1 mod, delta + 2
      false -> delta
    end
  end

  @doc """
  Generates random integer of the given length in bits.
  """
  @spec rand_integer(pos_integer) :: pos_integer
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
  Determines whether the given integer x is a prime according to n Miller-Rabin tests.
  """
  @spec probably_prime(pos_integer) :: boolean
  @spec probably_prime(pos_integer, pos_integer) :: boolean
  def probably_prime x, n \\ 20
  def probably_prime(x, _) when x < 2, do: false
  def probably_prime(x, _) when rem(x, 2) == 0, do: x == 2
  def probably_prime(x, n) do
    miller_rabin_test x, n
  end

  @doc """
  Performs n Miller-Rabin tests to check whether x is prime.
  If x is prime, it returns true.
  If x is not prime, it returns false with probability at least 1 - ¼ⁿ.
  """
  @spec miller_rabin_test(pos_integer) :: boolean
  @spec miller_rabin_test(pos_integer, pos_integer) :: boolean
  def miller_rabin_test x, n \\ 20
  def miller_rabin_test x, n do
    {d, s} = find_ds x
    as = rand_a(x, n)
    not Enum.any? as, fn a -> fermat_test(a, d, s, x) end
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
  @spec pow_mod(integer, pos_integer, pos_integer) :: integer
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