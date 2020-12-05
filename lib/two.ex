defmodule Adventofcode2020.Two do
  @passwords File.read!("data/two.txt")
             |> String.split("\n", trim: true)
             |> Enum.map(fn string ->
               # 9-12 q: qqqxhnhdmqqqqjz
               # ["9-12 q", " qqqxhnhdmqqqqjz"]
               [rule, password] = String.split(string, ":")
               password = String.trim(password)
               # ["9-12", "q"]
               [numbers, letter] = String.split(rule, " ")

               [min, max] =
                 String.split(numbers, "-")
                 |> Enum.map(&String.to_integer/1)

               {[min, max], letter, password}
             end)

  def first do
    Enum.count(@passwords, fn {[min, max], letter, password} ->
      follows_first_rule?(password, {[min, max], letter})
    end)
  end

  def second do
    Enum.count(@passwords, fn {[min, max], letter, password} ->
      follows_second_rule?(password, {[min, max], letter})
    end)
  end

  defp follows_first_rule?(password, {[min, max], letter}) do
    count =
      Regex.scan(~r/#{letter}/, password)
      |> Enum.count()

    count <= max && count >= min
  end

  defp follows_second_rule?(password, {[min, max], letter}) do
    letters = String.codepoints(password)

    (Enum.at(letters, min - 1) == letter &&
       Enum.at(letters, max - 1) != letter) ||
      (Enum.at(letters, min - 1) != letter &&
         Enum.at(letters, max - 1) == letter)
  end
end
