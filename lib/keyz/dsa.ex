defmodule Keyz.DSA do
  @moduledoc """
  Module to generate DSA keys.
  """

  use Bitwise
  alias Keyz.Prime
  alias Keyz.Util

  ### Valid set of DSA parameter sizes
  @valid_dsa_parameter_sizes [{1024, 160}, {2048, 224}, {2048, 256}, {3072, 256}]

  ### The number of Miller-Rabin primality tests that we perform
  @num_mr_tests 64

  @doc """
  Generates DSA key with the given parameter sizes.
  """
  @spec generate :: String.t
  @spec generate(pos_integer) :: String.t
  @spec generate(pos_integer, pos_integer) :: String.t
  def generate l \\ 2048, n \\ 256 do
    {p, q} = calculate_p_q l, n
    g = find_g p, q
    x = find_x q
    y = Prime.pow_mod g, x, p
    private_key = {:DSAPrivateKey, 0, p, q, g, y, x}
    Util.asn1_records_to_pem [{:DSAPrivateKey, private_key}]
  end

  defp calculate_p_q l, n do
    unless {l, n} in @valid_dsa_parameter_sizes, do: raise "invalid DSA parameter sizes"
    q = Prime.rand_prime n, @num_mr_tests
    p = find_p q, 4 * l, l, n
    {p, q}
  end

  defp find_p(_, 0, l, n), do: calculate_p_q l, n
  defp find_p(q, i, l, n) do
    r = Prime.rand_integer(l) |> bor(1)
    mod = rem(r, q) - 1
    p = r - mod
    case Util.integer_bit_size(p) < l or not Prime.probably_prime(p, @num_mr_tests) do
      true  -> find_p q, i - 1, l, n
      false -> p
    end
  end

  defp find_g p, q do
    h = 2
    pm1 = p - 1
    e = div pm1, q
    find_g1 h, e, p
  end
  defp find_g1 h, e, p do
     case g = Prime.pow_mod(h, e, p) do
       1 -> find_g1 h + 1, e, p
       _ -> g
     end
  end

  defp find_x q do
    bits = Util.integer_bit_size(q)
    x = Prime.rand_integer bits
    case x != 0 and x < q do
      true  -> x
      false -> find_x q
    end
  end

  @doc """
  Returns public key in PEM binary corresponding to the given DSA key PEM binary.
  """
  @spec public_key(String.t) :: String.t
  def public_key pem do
    [private_key_pem] = :public_key.pem_decode pem
    private_key = :public_key.pem_entry_decode private_key_pem
    {:DSAPrivateKey, 0, p, q, g, y, _} = private_key
    dss_parms = {:'Dss-Parms', p, q, g}
    dss_parms_der = :public_key.der_encode :'Dss-Parms', dss_parms
    public_key_der = :public_key.der_encode :DSAPublicKey, y
    oid = :pkey_cert_records.public_key_algorithm_oid :DSAPublicKey
    ai = {:AlgorithmIdentifier, oid, dss_parms_der}
    spki = {:SubjectPublicKeyInfo, ai, public_key_der}
    Util.asn1_records_to_pem [{:SubjectPublicKeyInfo, spki}]
  end
end