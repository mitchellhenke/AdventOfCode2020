defmodule Adventofcode2020.Three do
  @lines File.read!("data/three.txt")
         |> String.split("\n", trim: true)
         |> Enum.map(&String.codepoints/1)

  def first do
    traverse_slope(@lines, 1)
  end

  def second do
    every_other = Enum.drop_every([0 | @lines], 2)

    [
      {@lines, 1},
      {@lines, 3},
      {@lines, 5},
      {@lines, 7},
      {every_other, 1}
    ]
    |> Enum.reduce(1, fn {lines, x_step}, acc ->
      {_, num_trees} = traverse_slope(lines, x_step)
      acc * num_trees
    end)
  end

  defp traverse_slope(lines, x_step) do
    # {horizontal, num_trees}
    Enum.reduce(lines, {0, 0}, fn line, {x, num_trees} ->
      position = rem(x, Enum.count(line))
      character = Enum.at(line, position)

      if character == "#" do
        {x + x_step, num_trees + 1}
      else
        {x + x_step, num_trees}
      end
    end)
  end
end
