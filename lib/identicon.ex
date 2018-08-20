defmodule Identicon do
  @moduledoc """
  Identicon takes a string and generates a 5x5 grid Icon based on that string.
  """
  def main(input_string) do
    input_string
    |> hash_input
    |> pick_color
    |> build_grid
  end

  def build_grid(%Identicon.Image{hex: hex} = image_struct) do
    hex
    |> Enum.chunk(3)
    |> Enum.map(&mirror_row/1)
  end

  def mirror_row(row) do
    [first, second, _] = row

    row ++ [second, first]
  end

  def pick_color(%Identicon.Image{hex: [r, g, b | _]} = image_struct) do
    %Identicon.Image{image_struct | color: {r, g, b}}
  end

  def hash_input(input_string) do
    hex = :crypto.hash(:md5, input_string)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end
end
