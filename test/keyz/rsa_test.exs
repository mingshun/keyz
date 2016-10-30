defmodule Keyz.RSATest do
  use ExUnit.Case

  alias Keyz.RSA

  ### openssl genrsa -out rsa.key 2048
  @test_pem """
  -----BEGIN RSA PRIVATE KEY-----
  MIIEpAIBAAKCAQEAwa0nb+pNsyWtt1RdqB+IRzB2cymdjStyjQf+yz8lMKMqP+XH
  ePgihGZfEqmr2YvrTvyGzQQOhrYSFdbtcHrzT6or/nE9D0bpwVojMM3jOujKFX4Y
  4/Vs5Z7flGH6CslJgpeGiOBQPRtMLxb+Q+0JdpBQ5tUiyKWX9ik3IuW3JL+b4FL+
  /w8uPc/uF3jUPM2cM9Y5+ndC+u+SUMNn0tHNB4m3vouDQJLwQKxcSEpWwY9BxAaf
  I635u/7ofC4Iv4ze2WwxJI1gkbLW5BX+aoG2JX0GTIitjdWt2sRzq5cOchVKge51
  GEj77kfV4AT577RpZv0deKj+cBe0ErSL87epSwIDAQABAoIBAQC96VN9e0wbebvg
  w9pejCTuYYgUnt792Xem8QsYM1/9VFGOfHtflDkMiPF69GMtm/Tt69Mm3257C7eq
  MKl9HSLOoDgpdNKB03BNh1xwc8L4NeJKtu4jQbo5YtMrxfMQdpYddwWV3BbyBH1s
  w2gqJRmdaB/caWyFQVNELuAA2S3/2ioW1+ZrO7ow4w88hlPP/LIFVskL+kBNF1np
  bXY2SckYuilCDHD+iY6w58/rk/MZaZaeWwYN1a1XChsx2UdW/1Y4VNX8XHwPE7Fa
  7ddnkBgavnUMA9E4RvYm+4EOXuy94nMPQhAXyvRUmrssRcohkFBafbIdLSsycOH+
  P4bCyEJxAoGBAOju5PxFuQPfzIGsjcuTt9o3HVbg9ogkzKV53l2WF9GMIq+lniZ4
  LUiOCaqO/2pj0T3Hn3gKaTjX/6xyEFBjcmx67lNNsrcY7x2t17AGkw+C367p37+P
  qBTl/W5jL68LaSIRteNGFKceVSIFsTLkkRamFb0wmpNVdRzGFn4DZRFJAoGBANTb
  DsXgom8zsLcDRRABSuAdgRhHLY75sA6jLoP3SrXHRxMz8P7OGXWS7H/oLjXpF0K9
  g8oW6EfhipO1GoIzg/C8Msgmz8sA8ieq4RmS46dH/SDpTp6triCpp88JygfhqIh4
  ClSJm0edxR9sO1kpYULU7OMUmkYvcPkh+oGpdznzAoGBALAThby857JqBikvyq/M
  pfmqF9+IhlM7ngaoLNMJlk+sYrvrsbTau0BRPjVTivddJNpSf9U56Xgyru4n+vUJ
  d4FRG76UyTdm/bmto5FIJvper7+EwsIHUcMaZ4x+JZloQryiLp/yZcI+R5REQUJ7
  TMGWInC0wOQGgVSS2IXBAzEhAoGAfTIXP1X/1G5Py2U18tL/ylAwRSpgZo7/+awL
  SP1jyQVcDbRoVEa+/MOdLSJQQ89EqjGz2WKd3uGO05Aa9mf8e9UF/WmuoJV+2MwO
  OC+IjTSvcvMnFffLylRfakw0s2wL57DLSqvhVD882V2cjrXjCh8Y8fuFPjDbPv24
  TRlzEfcCgYAiPz6DIINo1mEahMD5C0ch8sfeS1q5eVJlqH1uF6E0SqIXY4u7A2kK
  lCH55vR+mr/xsalbe7OaQBDbvRih/W0UouxozXFCOzL0b47uAtj4+e4TbMFxyopL
  X5sNbmTTU6oet6jEaU9unE7ed9a5FehSv2UHOBz8SDloC4mto7TmCw==
  -----END RSA PRIVATE KEY-----
  """
  ### openssl rsa -in rsa.key -pubout -out rsa.pub
  @test_public_key_pem """
  -----BEGIN PUBLIC KEY-----
  MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwa0nb+pNsyWtt1RdqB+I
  RzB2cymdjStyjQf+yz8lMKMqP+XHePgihGZfEqmr2YvrTvyGzQQOhrYSFdbtcHrz
  T6or/nE9D0bpwVojMM3jOujKFX4Y4/Vs5Z7flGH6CslJgpeGiOBQPRtMLxb+Q+0J
  dpBQ5tUiyKWX9ik3IuW3JL+b4FL+/w8uPc/uF3jUPM2cM9Y5+ndC+u+SUMNn0tHN
  B4m3vouDQJLwQKxcSEpWwY9BxAafI635u/7ofC4Iv4ze2WwxJI1gkbLW5BX+aoG2
  JX0GTIitjdWt2sRzq5cOchVKge51GEj77kfV4AT577RpZv0deKj+cBe0ErSL87ep
  SwIDAQAB
  -----END PUBLIC KEY-----
  """

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

  test "public_key" do
    public_key_pem = RSA.public_key @test_pem
    public_key_pem_tidy = String.replace public_key_pem, "\n", ""
    test_public_key_pem_tidy = String.replace @test_public_key_pem, "\n", ""
    assert test_public_key_pem_tidy == public_key_pem_tidy
  end
end