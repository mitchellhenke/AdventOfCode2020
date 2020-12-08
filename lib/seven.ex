defmodule Adventofcode2020.Seven do
  @external_resource "data/seven.txt"
  @inverse_bags File.read!("data/seven.txt")
                |> String.split("\n", trim: true)
                |> Enum.map(fn bag ->
                  [name, bags] = String.split(bag, " contain ", trim: true)

                  bags =
                    String.split(bags, ~r/,\s*/)
                    |> Enum.map(fn bag ->
                      [number, bag_type] = String.split(bag, " ", parts: 2)

                      bag_type =
                        String.replace(bag_type, "bags", "bag")
                        |> String.replace(".", "")

                      if number == "no" do
                        nil
                      else
                        {String.to_integer(number), bag_type}
                      end
                    end)

                  {String.replace(name, "bags", "bag"), bags}
                end)
                |> Enum.reduce(%{}, fn {bag_name, bags}, acc ->
                  if bags == [nil] do
                    acc
                  else
                    Enum.reduce(bags, acc, fn {count, inner_bag_name}, acc ->
                      Map.put_new(acc, bag_name, [])
                      |> Map.update(
                        inner_bag_name,
                        [{count, bag_name}],
                        &[{count, bag_name} | &1]
                      )
                    end)
                  end
                end)

  @bags File.read!("data/seven.txt")
        |> String.split("\n", trim: true)
        |> Enum.map(fn bag ->
          [name, bags] = String.split(bag, " contain ", trim: true)

          bags =
            String.split(bags, ~r/,\s*/)
            |> Enum.map(fn bag ->
              [number, bag_type] = String.split(bag, " ", parts: 2)

              bag_type =
                String.replace(bag_type, "bags", "bag")
                |> String.replace(".", "")

              if number == "no" do
                nil
              else
                {String.to_integer(number), bag_type}
              end
            end)

          {String.replace(name, "bags", "bag"), bags}
        end)
        |> Enum.reduce(%{}, fn {bag_name, bags}, acc ->
          if bags == [nil] do
            Map.put(acc, bag_name, [])
          else
            Map.put(acc, bag_name, bags)
          end
        end)

  def first do
    count_bags(@inverse_bags, "shiny gold bag", MapSet.new())
  end

  def second do
    count_all_bags(@bags, "shiny gold bag")
  end

  defp count_bags(bags_map, name, bag_set) do
    Map.fetch!(bags_map, name)
    |> do_count_bags(bag_set, bags_map)
  end

  defp do_count_bags([], bag_set, _bags_map), do: bag_set

  defp do_count_bags([{_count, bag} | rest], bag_set, bags_map) do
    bags = Map.get(bags_map, bag, [])
    do_count_bags(rest, do_count_bags(bags, MapSet.put(bag_set, bag), bags_map), bags_map)
  end

  defp count_all_bags(bags_map, bag_color) do
    bags = Map.get(bags_map, bag_color, [])

    Enum.reduce(bags, 1, fn {count, bag}, acc ->
      acc + count * count_all_bags(bags_map, bag)
    end)
  end
end
