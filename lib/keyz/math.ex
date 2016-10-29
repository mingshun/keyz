defmodule Keyz.Math do
  @moduledoc """
  Module to provide mathematical utilities.
  """

  @doc """
  Calculates integer power.
  """
  def pow(a, x) when x >= 0 do
    xb = Integer.digits x, 2
    pow1 a, xb, 1
  end

  defp pow1 _, [], product do product end
  defp pow1 a, xb, product do
    [xi|xb1] = xb
    case xi do
      1 -> pow1 a, xb1, product * product * a
      0 -> pow1 a, xb1, product * product
    end
  end

  @doc """
  Calculates modular power.
  """
  def mod_pow(a, p, m) when p > 0 and m > 0 do
    pb = Integer.digits p, 2
    mod_pow1 a, pb, m, 1
  end

  defp mod_pow1 _, [], _, result do result end
  defp mod_pow1 a, pb, m, result do
    [pi | pb1] = pb
    result1 = rem result * result, m
    case pi do
      1 -> mod_pow1 a, pb1, m, rem(result1 * a, m)
      0 -> mod_pow1 a, pb1, m, rem(result1, m)
    end
  end
end