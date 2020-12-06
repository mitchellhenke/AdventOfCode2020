defmodule Adventofcode2020.Six do
  @external_resource "data/six.txt"
  @groups File.read!("data/six.txt")
          |> String.split("\n\n", trim: true)
          |> Enum.map(&String.split(&1, "\n", trim: true))

  def first do
    Enum.map(@groups, fn group ->
      Enum.join(group, "")
      |> String.codepoints()
      |> Enum.uniq()
      |> Enum.count()
    end)
    |> Enum.sum()
  end

  def second do
    Enum.map(@groups, fn group ->
      unique_questions =
        Enum.join(group, "")
        |> String.codepoints()
        |> Enum.uniq()

      Enum.count(unique_questions, fn unique_question ->
        Enum.all?(group, fn person ->
          String.contains?(person, unique_question)
        end)
      end)
    end)
    |> Enum.sum()
  end
end
