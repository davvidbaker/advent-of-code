defmodule Advent201902 do
  def run do
    IO.inspect(part1())
    IO.inspect(part2())
  end

  def part1 do
    read_program()
    |> List.replace_at(1, 12)
    |> List.replace_at(2, 2)
    |> execute_program(0)
  end

  def part2 do
    ops = read_program()

    {n, v, _x} =
      for noun <- 0..99, verb <- 0..99 do
        {noun, verb,
         ops
         |> List.replace_at(1, noun)
         |> List.replace_at(2, verb)
         |> execute_program(0)}
      end
      |> Enum.find(fn {_noun, _verb, x} -> x == 19_690_720 end)

    n * 100 + v
  end

  def execute_program(ops, pointer) do
    [opcode | tail] =
      ops
      |> Enum.split(pointer)
      |> elem(1)
      |> Enum.take(4)

    case opcode do
      99 ->
        List.first(ops)

      1 ->
        [p1, p2, p3] = tail

        execute_program(
          ops
          |> List.replace_at(p3, Enum.at(ops, p1) + Enum.at(ops, p2)),
          pointer + 4
        )

      2 ->
        [p1, p2, p3] = tail

        execute_program(
          ops
          |> List.replace_at(p3, Enum.at(ops, p1) * Enum.at(ops, p2)),
          pointer + 4
        )
    end
  end

  def read_program do
    Advent.input_lines(2019, 2)
    |> Enum.to_list()
    |> List.first()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
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
