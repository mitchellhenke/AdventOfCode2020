defmodule Adventofcode2020.One do
  @numbers File.read!("data/one.txt")
           |> String.split("\n", trim: true)
           |> Enum.map(&String.to_integer/1)

  def first do
    first(@numbers, @numbers)
  end

  defp first([_ | rest], []) do
    first(rest, @numbers)
  end

  defp first([num1 | _rest_num1], [num2 | _restnum2]) when num1 + num2 == 2020,
    do: {num1, num2, num1 * num2}

  defp first(num1, [_num2 | restnum2]), do: first(num1, restnum2)

  def second do
    second(@numbers, @numbers, @numbers)
  end

  defp second([_ | rest], [], []) do
    second(rest, @numbers, @numbers)
  end

  defp second(numbers1, [_ | rest], []) do
    second(numbers1, rest, @numbers)
  end

  defp second([num1 | _rest_num1], [num2 | _restnum2], [num3 | _restnum3])
       when num1 + num2 + num3 == 2020 do
    {num1, num2, num3, num1 * num2 * num3}
  end

  defp second(num1, num2, [_ | restnum3]), do: second(num1, num2, restnum3)
end
