defmodule Adventofcode2020.Eight do
  @external_resource "data/eight.txt"
  @instructions File.read!("data/eight.txt")
                |> String.split("\n", trim: true)
                |> Enum.with_index()
                |> Enum.reduce(%{}, fn {instruction, index}, acc ->
                  Map.put(acc, index + 1, instruction)
                end)

  def first do
    executed_instructions = MapSet.new()
    acc = 0
    current_line = 1

    first(acc, current_line, executed_instructions, @instructions)
  end

  def second do
    Enum.reduce_while(@instructions, nil, fn {line, instruction}, nil ->
      cond do
        String.contains?(instruction, "jmp") ->
          changed_instructions =
            Map.put(@instructions, line, String.replace(instruction, "jmp", "nop"))

          second(0, 1, MapSet.new(), changed_instructions)
          |> case do
            {:error, :infinite} ->
              {:cont, nil}

            {:success, acc} ->
              {:halt, acc}
          end

        String.contains?(instruction, "nop") ->
          changed_instructions =
            Map.put(@instructions, line, String.replace(instruction, "nop", "jmp"))

          second(0, 1, MapSet.new(), changed_instructions)
          |> case do
            {:error, :infinite} ->
              {:cont, nil}

            {:success, acc} ->
              {:halt, acc}
          end

        true ->
          {:cont, nil}
      end
    end)
  end

  def second(acc, line, executed_instructions, instructions) do
    cond do
      MapSet.member?(executed_instructions, line) ->
        {:error, :infinite}

      line == 623 ->
        {:success, acc}

      true ->
        executed_instructions = MapSet.put(executed_instructions, line)
        {acc, next_line} = next_instruction(acc, line, instructions)

        second(acc, next_line, executed_instructions, instructions)
    end
  end

  def first(acc, line, executed_instructions, instructions) do
    if MapSet.member?(executed_instructions, line) do
      acc
    else
      executed_instructions = MapSet.put(executed_instructions, line)
      {acc, next_line} = next_instruction(acc, line, instructions)

      first(acc, next_line, executed_instructions, instructions)
    end
  end

  defp next_instruction(acc, line, instructions) do
    instruction = Map.fetch!(instructions, line)

    case String.split(instruction, " ") do
      ["nop", _] ->
        {acc, line + 1}

      ["jmp", jmp_instruction] ->
        {acc, String.to_integer(jmp_instruction) + line}

      ["acc", acc_instruction] ->
        {String.to_integer(acc_instruction) + acc, line + 1}
    end
  end
end
