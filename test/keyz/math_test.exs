defmodule Keyz.MathTest do
  
  use ExUnit.Case

  alias Keyz.Math

  test "calculates integer power" do
    assert 1024 == Math.pow 2, 10
    assert 2048 == Math.pow 2, 11
  end

  test "calculates modular power" do
    assert 1 == Math.mod_pow 1, 6, 7
    assert 1 == Math.mod_pow 2, 6, 7
    assert 1 == Math.mod_pow 3, 6, 7
    assert 1 == Math.mod_pow 4, 6, 7
    assert 1 == Math.mod_pow 5, 6, 7
    assert 1 == Math.mod_pow 6, 6, 7

    a = 2
    p = 6864797660130609714981900799081393217269435300143305409394463459185543183397656052122559640661454554977296311391480858037121987999716643812574028291115057150
    m = 6864797660130609714981900799081393217269435300143305409394463459185543183397656052122559640661454554977296311391480858037121987999716643812574028291115057151
    assert 1 == Math.mod_pow a, p, m
  end
end