defmodule Keyz.PrimeTest do

  use ExUnit.Case

  alias Keyz.Prime

  test "fermat test" do
    assert false == Prime.fermat_test 1
    assert false == Prime.fermat_test 1, 3

    assert true  == Prime.fermat_test 2
    assert true  == Prime.fermat_test 2, 3

    assert true  == Prime.fermat_test 7
    assert true  == Prime.fermat_test 7, 3

    # Carmichael number
    assert true  == Prime.fermat_test 561
    assert false == Prime.fermat_test 561, 3
    assert true  == Prime.fermat_test 561, 5
    assert true  == Prime.fermat_test 561, 7
    assert false == Prime.fermat_test 561, 11
    assert true  == Prime.fermat_test 561, 13
    assert false == Prime.fermat_test 561, 17
  end

  test "generate random integer with bits which is divisible by 8" do
    rand = Prime.rand_integer 2048
    rand_bits = :binary.encode_unsigned rand
    assert 2048 == bit_size rand_bits
    <<f :: size(1), _ :: bitstring>> = rand_bits
    assert f == 1
  end

  test "generate random integer with bits which is not divisible by 8" do
    rand = Prime.rand_integer 2045
    rand_bits = :binary.encode_unsigned rand
    assert 2048 == bit_size rand_bits
    <<f :: size(4), _ :: bitstring>> = rand_bits
    assert f == 1
  end
end