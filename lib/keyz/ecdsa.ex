defmodule Keyz.ECDSA do
  @moduledoc """
  Module to generate ECDSA keys.
  """

  @doc """
  Generates ECDSA key with the given curve id, and returns in PEM binary.
  """
  def generate curve_id do
    {public_key, private_key} = :crypto.generate_key :ecdh, curve_id
    params_entity = {:namedCurve, :pubkey_cert_records.namedCurves(curve_id)}
    key_entity = {:ECPrivateKey,
                 1,
                 :erlang.binary_to_list(private_key),
                 params_entity,
                 public_key}
    params_der_encoded = :public_key.der_encode :EcpkParameters, params_entity
    key_der_encoded = :public_key.der_encode :ECPrivateKey, key_entity
    params_pem_encoded = :public_key.pem_encode [{:EcpkParameters, 
                                                  params_der_encoded, 
                                                  :not_encrypted}]
    key_pem_encoded = :public_key.pem_encode [{:ECPrivateKey, 
                                               key_der_encoded, 
                                               :not_encrypted}]
    String.replace params_pem_encoded <> key_pem_encoded, "\n\n", "\n"
  end
end