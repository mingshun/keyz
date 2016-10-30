defmodule Keyz.RSA do
  @moduledoc """
  Module to generate RSA keys.
  """

  alias Keyz.Prime
  alias Keyz.Util

  ### The public exponent value F0 = 3
  @f0 0x3
  ### The public exponent value F4 = 65537
  @f4 0x10001

  @doc """
  Generates RSA key with the given curve id, and returns in PEM binary.
  """
  @spec generate :: String.t
  @spec generate(pos_integer) :: String.t
  @spec generate(pos_integer, pos_integer) :: String.t
  def generate bits \\ 2048, e \\ @f4 do
    {p, q, n} = generate_pq bits

    # phi = (p - 1) * (q - 1) must be relative prime to e, otherwise RSA just won't work.
    p1 = p - 1
    q1 = q - 1
    phi = p1 * q1
    if Util.gcd(e, phi) != 1, do: generate bits, e

    # Private exponent d is the inverse of e mod phi.
    d = Util.mod_inverse e, phi

    # 1st prime exponent pe = d mod (p - 1)
    pe = rem d, p1
    # 2nd prime exponent qe = d mod (q - 1)
    qe = rem d, q1

    # Certificate coefficient coeff is the inverse of q mod p.
    coeff = Util.mod_inverse q, p

    private_key = {:RSAPrivateKey, :"two-prime", n, e, d, p, q, pe, qe, coeff, :asn1_NOVALUE}
    private_key_der = :public_key.der_encode :RSAPrivateKey, private_key
    :public_key.pem_encode [{:RSAPrivateKey, private_key_der, :not_encrypted}]
  end

  defp generate_pq bits do
    p_len = div bits + 1, 2
    q_len = bits - p_len
    p = Prime.rand_prime p_len
    q = Prime.rand_prime q_len
    n = p * q
    if Util.integer_bit_size(n) < bits, do: generate_pq bits
    case p > q do
      true  -> {p, q, n}
      false -> {q, p, n}
    end
  end

  @doc """
  Returns public key in PEM binary corresponding to the given RSA key PEM binary.
  """
  @spec public_key(String.t) :: String.t
  def public_key pem do
    [private_key_pem] = :public_key.pem_decode pem
    private_key = :public_key.pem_entry_decode private_key_pem
    {:RSAPrivateKey, _, n, e, _, _, _, _, _, _, _} = private_key
    public_key = {:RSAPublicKey, n, e}
    public_key_der = :public_key.der_encode :RSAPublicKey, public_key
    oid = :pkey_cert_records.public_key_algorithm_oid :RSAPublicKey
    ai = {:AlgorithmIdentifier, oid, :pkey_cert_records.der_null}
    spki = {:SubjectPublicKeyInfo, ai, public_key_der}
    spki_der = :public_key.der_encode :SubjectPublicKeyInfo, spki
    :public_key.pem_encode [{:SubjectPublicKeyInfo, spki_der, :not_encrypted}]
  end

end