defmodule Identicon do
  @moduledoc """
  Identicon takes a string and generates a 5x5 grid Icon based on that string.
  """
  def main(input_string) do
    input_string
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input_string)
  end

  def save_image(image, input_string) do
    File.write("#{input_string}_Identicon.png", image)
  end

  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each pixel_map, fn({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end

    :egd.render(image)
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image_struct) do
    pixel_map = Enum.map grid, fn({_num, index}) ->
      horizontal = rem(index, 5) * 50
      vertical = div(index, 5) * 50

      top_left = {horizontal, vertical}
      bottom_right = {horizontal + 50, vertical + 50}

      {top_left, bottom_right}
    end

    %Identicon.Image{image_struct | pixel_map: pixel_map}
  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image_struct) do
    grid = Enum.filter grid, fn({num, _index}) ->
      rem(num, 2) == 0
    end

    %Identicon.Image{image_struct | grid: grid}
  end

  def build_grid(%Identicon.Image{hex: hex} = image_struct) do
    grid =
      hex
      |> Enum.chunk(3)
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      |> Enum.with_index

      %Identicon.Image{image_struct | grid: grid}
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
