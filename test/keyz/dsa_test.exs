defmodule Keyz.DSATest do
  use ExUnit.Case

  alias Keyz.DSA

  ### openssl dsaparam -out dsa.key -genkey 2048
  @test_pem """
  -----BEGIN DSA PARAMETERS-----
  MIICIAKCAQEA4984J3q55KbHR/4t2MX7nvv8y0RMk4Nk/b+pECv9+FopBqJvZFW2
  xsfsNGMS7rj5ScU6bsA7AaP8wKdC7fcOmEIbwwE1+IvWs8oHBtWU6WuOmFjvgm9s
  q67I7po29NyHr9ZwYozrZL7J2CkatehQjImKXEw9XPv6QhUVcjQhsTRxrzCYVJt5
  rUa+GeCsH2t0PhiXSbHDPkUmc/ArB4ZFH4H5SQw50MKMNrzarNIuqTj9edMsli3U
  03fafGbm2RAzGaE13trz8uWaXiCjc/u2tA5tGCaXMovFmNpIo9Jzj/OrH4FFzUTS
  LCpfW1ToFF/zM4p2TaY/pmx64PCWanWSyQIVAL3j94w+MO/vV2S6L2nVoCWLoyfF
  AoIBAGy9oz4A/9dxsiXipknCmzBRQ5H2E2RcmlWVZOUJoixV7rMUIuyDi2c787zf
  TTEodtuU76Q2PHH7IhB+6B9/3bY1VUeWDNqEYwOxwUX5zWfSEyv+3PdKTDViI1oT
  Ja437SNVmWTDlPUpn0sMC2IqIUPOqENGFAlfi9PphxkcZYpr5FygsK5cvtaZtalc
  JPJUNxsA6UMEGFfz5vVqIjTFIllLr5mfzZZK9kKebMXqEAmIOBx9Ibabau6oHrqR
  WqoIg2ws3O1ijQFCZfpVeaW7fVF5aPCzicdhOypfPpXllrdUOiorQechiwgNlfoD
  XD8n9pdIqt/OYWIP7VsTb/0u25Y=
  -----END DSA PARAMETERS-----
  -----BEGIN DSA PRIVATE KEY-----
  MIIDPwIBAAKCAQEA4984J3q55KbHR/4t2MX7nvv8y0RMk4Nk/b+pECv9+FopBqJv
  ZFW2xsfsNGMS7rj5ScU6bsA7AaP8wKdC7fcOmEIbwwE1+IvWs8oHBtWU6WuOmFjv
  gm9sq67I7po29NyHr9ZwYozrZL7J2CkatehQjImKXEw9XPv6QhUVcjQhsTRxrzCY
  VJt5rUa+GeCsH2t0PhiXSbHDPkUmc/ArB4ZFH4H5SQw50MKMNrzarNIuqTj9edMs
  li3U03fafGbm2RAzGaE13trz8uWaXiCjc/u2tA5tGCaXMovFmNpIo9Jzj/OrH4FF
  zUTSLCpfW1ToFF/zM4p2TaY/pmx64PCWanWSyQIVAL3j94w+MO/vV2S6L2nVoCWL
  oyfFAoIBAGy9oz4A/9dxsiXipknCmzBRQ5H2E2RcmlWVZOUJoixV7rMUIuyDi2c7
  87zfTTEodtuU76Q2PHH7IhB+6B9/3bY1VUeWDNqEYwOxwUX5zWfSEyv+3PdKTDVi
  I1oTJa437SNVmWTDlPUpn0sMC2IqIUPOqENGFAlfi9PphxkcZYpr5FygsK5cvtaZ
  talcJPJUNxsA6UMEGFfz5vVqIjTFIllLr5mfzZZK9kKebMXqEAmIOBx9Ibabau6o
  HrqRWqoIg2ws3O1ijQFCZfpVeaW7fVF5aPCzicdhOypfPpXllrdUOiorQechiwgN
  lfoDXD8n9pdIqt/OYWIP7VsTb/0u25YCggEBAKDp7JrL7nOvcIVMZLZ2HgW6bUEr
  D2OP1znyQaATvI7bjDVHdMRGgBQNpoAze2BjDtkPGgGnBwhBkyP2P0dgRECf98ow
  IJ7ztEK1mw5o9iQ6tIrkTgrHpCu97HVxoHOGCV2Jfv7LOE93YbrlHEGKyoLgRbPs
  CSL1E4RYlz6Pj4ae6zPEAxadNGIYfnr+Eny5yPT4Ha9axymxKE9HTUzLsPSRVnnc
  DNOigYpMOxY86njkRhIPHn6kULQ1fANkpEj0S4Vkyd46ZKWehFfg+0tSKatZQ+B9
  sNqTkJWs0Hp2uP8iO6OKCBfY9+1eQXq4OWbKfZ8ur+CiT5OD9CgF4Ie/MScCFQCz
  B2D3X+ZG/bmvV0wjrePbc8p96Q==
  -----END DSA PRIVATE KEY-----
  """
  ### openssl dsa -in dsa.key -pubout -out dsa.pem
  @test_public_key_pem """
  -----BEGIN PUBLIC KEY-----
  MIIDOzCCAi0GByqGSM44BAEwggIgAoIBAQDj3zgnernkpsdH/i3Yxfue+/zLREyT
  g2T9v6kQK/34WikGom9kVbbGx+w0YxLuuPlJxTpuwDsBo/zAp0Lt9w6YQhvDATX4
  i9azygcG1ZTpa46YWO+Cb2yrrsjumjb03Iev1nBijOtkvsnYKRq16FCMiYpcTD1c
  +/pCFRVyNCGxNHGvMJhUm3mtRr4Z4Kwfa3Q+GJdJscM+RSZz8CsHhkUfgflJDDnQ
  wow2vNqs0i6pOP150yyWLdTTd9p8ZubZEDMZoTXe2vPy5ZpeIKNz+7a0Dm0YJpcy
  i8WY2kij0nOP86sfgUXNRNIsKl9bVOgUX/MzinZNpj+mbHrg8JZqdZLJAhUAveP3
  jD4w7+9XZLovadWgJYujJ8UCggEAbL2jPgD/13GyJeKmScKbMFFDkfYTZFyaVZVk
  5QmiLFXusxQi7IOLZzvzvN9NMSh225TvpDY8cfsiEH7oH3/dtjVVR5YM2oRjA7HB
  RfnNZ9ITK/7c90pMNWIjWhMlrjftI1WZZMOU9SmfSwwLYiohQ86oQ0YUCV+L0+mH
  GRxlimvkXKCwrly+1pm1qVwk8lQ3GwDpQwQYV/Pm9WoiNMUiWUuvmZ/Nlkr2Qp5s
  xeoQCYg4HH0htptq7qgeupFaqgiDbCzc7WKNAUJl+lV5pbt9UXlo8LOJx2E7Kl8+
  leWWt1Q6KitB5yGLCA2V+gNcPyf2l0iq385hYg/tWxNv/S7blgOCAQYAAoIBAQCg
  6eyay+5zr3CFTGS2dh4Fum1BKw9jj9c58kGgE7yO24w1R3TERoAUDaaAM3tgYw7Z
  DxoBpwcIQZMj9j9HYERAn/fKMCCe87RCtZsOaPYkOrSK5E4Kx6Qrvex1caBzhgld
  iX7+yzhPd2G65RxBisqC4EWz7Aki9ROEWJc+j4+GnuszxAMWnTRiGH56/hJ8ucj0
  +B2vWscpsShPR01My7D0kVZ53AzTooGKTDsWPOp45EYSDx5+pFC0NXwDZKRI9EuF
  ZMneOmSlnoRX4PtLUimrWUPgfbDak5CVrNB6drj/IjujiggX2PftXkF6uDlmyn2f
  Lq/gok+Tg/QoBeCHvzEn
  -----END PUBLIC KEY-----
  """

  test "generate keypair" do
    private_key = DSA.generate_private_key 1024, 160
    public_key = DSA.public_key_of private_key

    msg = :crypto.strong_rand_bytes 32
    signature = :public_key.sign msg, :sha, private_key
    verify = :public_key.verify msg, :sha, signature, public_key
    assert verify
  end

  test "public_key" do
    public_key_pem = DSA.public_key @test_pem
    public_key_pem_tidy = String.replace public_key_pem, "\n", ""
    test_public_key_pem_tidy = String.replace @test_public_key_pem, "\n", ""
    assert test_public_key_pem_tidy == public_key_pem_tidy
  end

end