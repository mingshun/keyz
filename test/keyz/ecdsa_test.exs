defmodule Keyz.ECDSATest do
  use ExUnit.Case

  alias Keyz.ECDSA

  test "generate" do
    pem = ECDSA.generate :secp256k1
    [ec_params_der, ec_private_key_der] = :public_key.pem_decode pem
    ec_params = :public_key.pem_entry_decode ec_params_der
    ec_private_key = :public_key.pem_entry_decode ec_private_key_der
    ec_point = {:ECPoint, ec_private_key |> elem(4)}
    ec_public_key = {ec_point, ec_params}

    msg = :crypto.strong_rand_bytes 32
    signature = :public_key.sign msg, :sha256, ec_private_key
    verify = :public_key.verify msg, :sha256, signature, ec_public_key
    assert verify
  end
end