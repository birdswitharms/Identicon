defmodule Identicon do
  @moduledoc """
  Identicon takes a string and generates a 5x5 grid Icon based on that string.
  """
  def main(input_string) do
    input_string
    |> hash_input
  end

  def hash_input(input_string) do
    hex = :crypto.hash(:md5, input_string)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end
end
