defmodule Adventofcode2020.Five do
  @external_resource "data/five.txt"
  @passports File.read!("data/five.txt")
             |> String.split("\n", trim: true)

  def first do
    Enum.map(@passports, fn pass ->
      {row, column} = convert_pass_to_row_column(pass)

      row * 8 + column
    end)
    |> Enum.max()
  end

  # ignore ID 0-7 and 1016-1023
  def second do
    Enum.map(@passports, fn pass ->
      {row, column} = convert_pass_to_row_column(pass)

      row * 8 + column
    end)
    |> Enum.filter(fn id ->
      id > 7 && id < 1016
    end)
    |> Enum.sort()
    |> Enum.reduce_while(nil, fn id, acc ->
      cond do
        acc == nil ->
          {:cont, id}

        id - acc == 1 ->
          {:cont, id}

        id - acc == 2 ->
          {:halt, acc + 1}
      end
    end)
  end

  defp convert_pass_to_row_column(pass) do
    {row, column} = String.split_at(pass, 7)

    row =
      String.replace(row, "F", "0")
      |> String.replace("B", "1")
      |> String.to_integer(2)

    column =
      String.replace(column, "R", "1")
      |> String.replace("L", "0")
      |> String.to_integer(2)

    {row, column}
  end
end
