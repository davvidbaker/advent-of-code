defmodule Advent201901 do
  def run do
    IO.inspect(part1())
    IO.inspect(part2())
  end

  def part1 do
    module_masses()
    |> Stream.map(&fuel_given_mass/1)
    |> Enum.sum()
  end

  def part2 do
    module_masses()
    |> Stream.map(&fuel_given_mass_recursive/1)
    |> Enum.sum()
  end

  def module_masses do
    Advent.input_lines(2019, 1)
    |> Stream.map(&String.to_integer/1)
  end

  def fuel_given_mass(mass) do
    mass
    |> Integer.floor_div(3)
    |> Kernel.-(2)
  end

  def fuel_given_mass_recursive(mass) do
    fuel = fuel_given_mass(mass)

    if fuel > 0 do
      fuel + fuel_given_mass_recursive(fuel)
    else
      0
    end
  end
end
