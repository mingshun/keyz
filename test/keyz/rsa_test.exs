defmodule Keyz.RSATest do
  use ExUnit.Case

  alias Keyz.RSA

  test "generate" do
    pem = RSA.generate
    [private_key_pem] = :public_key.pem_decode pem
    private_key = :public_key.pem_entry_decode private_key_pem
    {:RSAPrivateKey, _, n, e, _, _, _, _, _, _, _} = private_key
    public_key = {:RSAPublicKey, n, e}

    msg = :crypto.strong_rand_bytes 32
    signature = :public_key.sign msg, :sha256, private_key
    verify = :public_key.verify msg, :sha256, signature, public_key
    assert verify
  end
end