defmodule Keyz.ECDSATest do
  use ExUnit.Case

  alias Keyz.ECDSA

  ### openssl ecparam -out ecdsa.pem -name secp256k1 -genkey
  @test_pem """
  -----BEGIN EC PARAMETERS-----
  BgUrgQQACg==
  -----END EC PARAMETERS-----
  -----BEGIN EC PRIVATE KEY-----
  MHQCAQEEIIa5Qh2LojbXXiEGWKukoc2CAx/1MJpjtib+QbLxyZW0oAcGBSuBBAAK
  oUQDQgAEYtGFaHcu0Ig+pPL/jV5Flf3RLBYKNmylfByy+DcW4XfHMeS30d62JWjC
  JzxoaTEREM61O6YwSiflQa37kU4eUw==
  -----END EC PRIVATE KEY-----
  """
  ### openssl ec -in ecdsa.pem -pubout -out ecdsa.pub
  @test_public_key_pem """
  -----BEGIN PUBLIC KEY-----
  MFYwEAYHKoZIzj0CAQYFK4EEAAoDQgAEYtGFaHcu0Ig+pPL/jV5Flf3RLBYKNmyl
  fByy+DcW4XfHMeS30d62JWjCJzxoaTEREM61O6YwSiflQa37kU4eUw==
  -----END PUBLIC KEY-----
  """
  ### openssl ec -in ecdsa.pem -pubout -outform der | openssl sha1 -c
  @test_fingerprint "82:33:e6:34:af:d4:0a:97:4f:f4:8a:82:69:0d:22:cb:d6:7e:02:be"

  test "generate" do
    pem = ECDSA.generate :secp256k1
    [ec_params_pem, ec_private_key_pem] = :public_key.pem_decode pem
    ec_params = :public_key.pem_entry_decode ec_params_pem
    ec_private_key = :public_key.pem_entry_decode ec_private_key_pem
    ec_point = {:ECPoint, ec_private_key |> elem(4)}
    ec_public_key = {ec_point, ec_params}

    msg = :crypto.strong_rand_bytes 32
    signature = :public_key.sign msg, :sha256, ec_private_key
    verify = :public_key.verify msg, :sha256, signature, ec_public_key
    assert verify
  end

  test "public_key" do
    public_key_pem = ECDSA.public_key @test_pem
    public_key_pem_tidy = String.replace public_key_pem, "\n", ""
    test_public_key_pem_tidy = String.replace @test_public_key_pem, "\n", ""
    assert test_public_key_pem_tidy == public_key_pem_tidy
  end
end