defmodule Advent201903 do
  def run do
    # IO.inspect(part1())
    IO.inspect(part2())
  end

  def part1 do
    [wire1_path, wire2_path] =
      Advent.input_lines(2019, 3)
      |> Enum.to_list()
      |> Enum.map(&String.split(&1, ","))

    # wire1_path = ~w[R8 U5 L5 D3]
    # wire2_path = ~w[U7 R6 D4 L4]

    # wire1_path = ~w[R75 D30 R83 U83 L12 D49 R71 U7 L72]
    # wire2_path = ~w[U62 R66 U55 R34 D71 R55 D58 R83]

    # wire1_path = ~w[R98 U47 R26 D63 R33 U87 L62 D20 R33 U53 R51]
    # wire2_path = ~w[U98 R91 D20 R16 D67 R40 U7 R15 U6 R7]

    {wire1_plot, _steps} = populate_wire_positions(%{}, wire1_path, {0, 0})
    {wire2_plot, _steps} = populate_wire_positions(%{}, wire2_path, {0, 0})

    intersections = find_intersections(wire1_plot, wire2_plot)
    IO.inspect(intersections, label: "intersections")

    # ⚠️ extraneous distance of 1 in there somehow
    intersection_distances =
      intersections |> Enum.map(fn {x, y} -> abs(x) + abs(y) end) |> Enum.sort()

    IO.inspect(intersection_distances, label: "intersection_distances")
  end

  def part2 do
    [wire1_path, wire2_path] =
      Advent.input_lines(2019, 3)
      |> Enum.to_list()
      |> Enum.map(&String.split(&1, ","))

    # wire1_path = ~w[R8 U5 L5 D3]
    # wire2_path = ~w[U7 R6 D4 L4]

    # wire1_path = ~w[R75 D30 R83 U83 L12 D49 R71 U7 L72]
    # wire2_path = ~w[U62 R66 U55 R34 D71 R55 D58 R83]

    # wire1_path = ~w[R98 U47 R26 D63 R33 U87 L62 D20 R33 U53 R51]
    # wire2_path = ~w[U98 R91 D20 R16 D67 R40 U7 R15 U6 R7]

    {wire1_plot, _steps} = populate_wire_positions(%{}, wire1_path, {0, 0})
    {wire2_plot, _steps} = populate_wire_positions(%{}, wire2_path, {0, 0})

    intersections = find_intersections(wire1_plot, wire2_plot)
    IO.puts("")
    IO.inspect(intersections, label: "intersections")

    wire1_distances_to_intersection =
      intersections
      |> Enum.map(fn intersection ->

        IO.puts ""
        IO.inspect(label: "😲😲😲😲😲")
        IO.inspect(intersection, label: "intersection")
        populate_wire_positions(%{}, wire1_path, {0, 0}, intersection)
        |> elem(1)
      end)

    wire2_distances_to_intersection =
      intersections
      |> Enum.map(fn intersection ->
        IO.puts ""
        IO.inspect(label: "😲😲😲😲😲")
        IO.inspect(intersection, label: "intersection")
        populate_wire_positions(%{}, wire2_path, {0, 0}, intersection, 0) |> elem(1)
      end)

    IO.inspect(wire1_distances_to_intersection, label: "wire1_distances_to_intersection")
    IO.inspect(wire2_distances_to_intersection, label: "wire2_distances_to_intersection")

    Enum.zip(wire1_distances_to_intersection, wire2_distances_to_intersection)
    |> Enum.map(fn {a, b} -> a + b end)
    |> Enum.min()
  end

  def find_intersections(plot1, plot2) do
    common_x =
      MapSet.intersection(
        MapSet.new(Map.keys(plot1)),
        MapSet.new(Map.keys(plot2))
      )

    common_x
    |> Enum.reduce([], fn x, acc ->
      common_y =
        MapSet.intersection(
          plot1[x],
          plot2[x]
        )

      [
        common_y
        |> Enum.reduce([], fn y, acc2 ->
          [{x, y} | acc2]
        end)
        | acc
      ]
    end)
    |> List.flatten()
  end

  def populate_wire_positions(plot, path, pointer, intersection \\ {nil, nil}, steps \\ 0) do
    [instruction | remaining_path] = path

    {plot, pointer, steps_taken} = plot_instruction(plot, instruction, pointer, intersection)

    if plot == :halt do
      {plot, steps_taken + steps}
    else
      case length(remaining_path) do
        0 ->
          {plot, steps_taken + steps}

        _ ->
          populate_wire_positions(
            plot,
            remaining_path,
            pointer,
            intersection,
            steps_taken + steps
          )
      end
    end
  end

  def plot_instruction(plot, instruction, pointer, intersection \\ {nil, nil}) do
    %{"direction" => direction, "distance" => distance} =
      Regex.named_captures(~r/(?<direction>\w)(?<distance>\d+)/, instruction)

    distance = String.to_integer(distance)

    {plot, pointer, steps_taken} =
      case direction do
        "U" ->
          {plot, pointer, intersection} |> draw(0, 1 * distance)

        "D" ->
          {plot, pointer, intersection} |> draw(0, -1 * distance)

        "L" ->
          {plot, pointer, intersection} |> draw(-1 * distance, 0)

        "R" ->
          {plot, pointer, intersection} |> draw(1 * distance, 0)
      end

    {plot, pointer, steps_taken}
  end

  @spec draw({any, {number, number}, {any, any}}, number, number) :: {any, {number, number}, any}
  def draw({plot, {pointer_x, pointer_y}, {intersection_x, intersection_y}}, x_dist, y_dist) do
    x_end = pointer_x + x_dist
    y_end = pointer_y + y_dist

    one_move_x = if x_dist < 0, do: -1, else: 1
    one_move_y = if y_dist < 0 , do: -1, else: 1

    x_range = (pointer_x + one_move_x)..x_end
    y_range = (pointer_y + one_move_y)..y_end

    {plot, steps_taken} =
      case x_dist do
        0 ->
          {plot, 0}

        _ ->
          x_range
          |> Enum.reduce_while({plot, 0}, fn x, {acc, acc_steps} ->
            if x == intersection_x && pointer_y == intersection_y do
              {:halt, {:halt, acc_steps + 1}}
            else
              {:cont,
               {acc
                |> Map.update(x, MapSet.new([pointer_y]), &MapSet.put(&1, pointer_y)),
                acc_steps + 1}}
            end
          end)
      end

    {plot, steps_taken} =
      if plot == :halt do
        {plot, steps_taken}
      else
        case y_dist do
          0 ->
            {plot, steps_taken}

          _ ->
            y_range
            |> Enum.reduce_while({plot, 0}, fn y, {acc, acc_steps} ->
              if pointer_x == intersection_x && y == intersection_y do

                {:halt, {:halt, acc_steps + 1}}
              else
                {:cont,
                 {acc |> Map.update(pointer_x, MapSet.new([y]), &MapSet.put(&1, y)),
                  acc_steps + 1}}
              end
            end)
        end
      end

    {plot, {x_end, y_end}, steps_taken}
  end
end
