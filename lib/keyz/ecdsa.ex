defmodule Keyz.ECDSA do
  @moduledoc """
  Module to generate ECDSA keys.
  """

  alias Keyz.Util

  @doc """
  Generates ECDSA key with the given curve id, and returns in PEM binary.
  """
  @spec generate(any) :: String.t
  def generate curve_id do
    {public_key, private_key} = :crypto.generate_key :ecdh, curve_id
    ec_params = {:namedCurve, :pubkey_cert_records.namedCurves(curve_id)}
    ec_private_key = {:ECPrivateKey, 1, private_key, ec_params, public_key}
    Util.asn1_records_to_pem [
      {:EcpkParameters, ec_params},
      {:ECPrivateKey, ec_private_key}
    ]
  end

  @doc """
  Returns public key in PEM binary corresponding to the given ECDSA key PEM binary.
  """
  @spec public_key(String.t) :: String.t
  def public_key pem do
    [ec_params_pem, ec_private_key_pem] = :public_key.pem_decode pem
    {:EcpkParameters, ec_params_der, _} = ec_params_pem
    ec_private_key = :public_key.pem_entry_decode ec_private_key_pem
    public_key = ec_private_key |> elem(4)
    oid = :pkey_cert_records.public_key_algorithm_oid :ECPoint
    ai = {:AlgorithmIdentifier, oid, ec_params_der}
    spki = {:SubjectPublicKeyInfo, ai, public_key}
    Util.asn1_records_to_pem [{:SubjectPublicKeyInfo, spki}]
  end
end