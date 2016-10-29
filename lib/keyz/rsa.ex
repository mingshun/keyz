defmodule Keyz.RSA do
  @moduledoc """
  Module to generate RSA keys.
  """

  # The public exponent value F0 = 3
  @f0 0x3
  # The public exponent value F4 = 65537
  @f4 0x10001

  @min_modulus_len 512
  @max_modulus_len 16384

  @max_modulus_len_restrict_exponent 3072
  @max_restricted_exponent_len       64

  @doc """
  Generates RSA key with given key size and public exponent value,
  and returns in PEM binary.
  """
  def generate key_size \\ 2048, exponent \\ @f4 do
    check_key_lengths key_size, @f4, 512, 64 * 1024
  end

  defp check_key_lengths modulus_len, exponent, min_modulus_len, max_modulus_len do
    if min_modulus_len > 0 and modulus_len < min_modulus_len do
      raise "RSA keys must be at least {min_modulus_len} bits long."
    end

    max_len = min max_modulus_len, @max_modulus_len
    if modulus_len > max_len do
      raise "RSA keys must be no longer than {max_len} bits."
    end
  end
end