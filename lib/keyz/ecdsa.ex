defmodule Keyz.ECDSA do
  @moduledoc """
  Module to generate ECDSA keys.
  """

  @doc """
  Generates ECDSA key with the given curve id, and returns in PEM binary.
  """
  def generate curve_id do
    {public_key, private_key} = :crypto.generate_key :ecdh, curve_id
    ec_params = {:namedCurve, :pubkey_cert_records.namedCurves(curve_id)}
    ec_private_key = {:ECPrivateKey, 1, private_key, ec_params, public_key}
    ec_params_der = :public_key.der_encode :EcpkParameters, ec_params
    ec_private_key_der = :public_key.der_encode :ECPrivateKey, ec_private_key
    :public_key.pem_encode [
      {:EcpkParameters, ec_params_der, :not_encrypted},
      {:ECPrivateKey, ec_private_key_der, :not_encrypted}
    ]
  end

  @doc """
  Returns public key in PEM binary corresponding to the given ECDSA key PEM binary.
  """
  def public_key pem do
    [ec_params_pem, ec_private_key_pem] = :public_key.pem_decode pem
    ec_params = :public_key.pem_entry_decode ec_params_pem
    ec_private_key = :public_key.pem_entry_decode ec_private_key_pem
    ec_point = {:ECPoint, ec_private_key |> elem(4)}
    ec_public_key = {ec_point, ec_params}
    spki_encoded = :public_key.pem_entry_encode :SubjectPublicKeyInfo, ec_public_key
    :public_key.pem_encode [spki_encoded]
  end
end