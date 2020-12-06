defmodule Adventofcode2020.Four do
  @external_resource "data/four.txt"
  @required_fields ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
  @passports File.read!("data/four.txt")
             |> String.split("\n\n", trim: true)
             |> Enum.map(fn passport ->
               String.split(passport, "\n")
               |> Enum.join(" ")
               |> String.trim()
               |> String.split(" ")
               |> Enum.map(fn field ->
                 [name, value] = String.split(field, ":")

                 {name, value}
               end)
               # %{"byr" => "2001", ...}
               |> Enum.into(%{})
             end)

  def first do
    Enum.filter(@passports, fn passport ->
      fields_present?(passport)
    end)
  end

  def second do
    Enum.filter(@passports, fn passport ->
      fields_present?(passport)
    end)
    |> Enum.filter(fn passport ->
      byr =
        Map.get(passport, "byr")
        |> String.to_integer()

      byr = byr >= 1920 && byr <= 2002

      iyr =
        Map.get(passport, "iyr")
        |> String.to_integer()

      iyr = iyr >= 2010 && iyr <= 2020

      eyr =
        Map.get(passport, "eyr")
        |> String.to_integer()

      eyr = eyr >= 2020 && eyr <= 2030

      hgt = Map.get(passport, "hgt")

      hgt =
        cond do
          String.ends_with?(hgt, "cm") ->
            [hgt, ""] = String.split(hgt, "cm")
            hgt = String.to_integer(hgt)
            hgt >= 150 && hgt <= 193

          String.ends_with?(hgt, "in") ->
            [hgt, ""] = String.split(hgt, "in")
            hgt = String.to_integer(hgt)
            hgt >= 59 && hgt <= 76

          true ->
            false
        end

      hcl = Map.get(passport, "hcl")
      hcl = Regex.match?(~r/\A#[0-9a-f]{6}\z/, hcl)
      ecl = Map.get(passport, "ecl")
      ecl = Enum.any?(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"], &(&1 == ecl))
      pid = Map.get(passport, "pid")
      pid = Regex.match?(~r/\A[0-9]{9}\z/, pid)

      pid && ecl && hcl && hgt && eyr && iyr && byr
    end)
    |> Enum.count()
  end

  defp fields_present?(passport) do
    keys =
      Map.take(passport, @required_fields)
      |> Map.keys()
      |> MapSet.new()

    required_keys = MapSet.new(@required_fields)

    keys == required_keys
  end
end
