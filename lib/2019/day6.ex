#
defmodule Advent201906 do
  def run do
    # IO.inspect(part1())
    IO.inspect(part2())
  end

  def part1 do
    orbits()
    |> to_tree()
    |> to_distance_map()
    |> Map.values()
    |> Enum.sum()
  end

  def part2 do
    orbit_tree =
      orbits()
      |> to_tree()

    distance_map = to_distance_map(orbit_tree)

    common_ancestor = get_common_ancestor(orbit_tree, "YOU", "SAN")

    Map.get(distance_map, "YOU") + Map.get(distance_map, "SAN") -
      2 * Map.get(distance_map, common_ancestor) - 2
  end

  def get_common_ancestor(tree, node1, node2) do
    node1_ancestry = ancestry([], node1, tree) |> Enum.reverse()
    node2_ancestry = ancestry([], node2, tree) |> Enum.reverse()

    node1_ancestry |> Enum.find(fn x -> Enum.member?(node2_ancestry, x) end)
  end

  def ancestry(ancestor_list, node, tree) do
    case tree
         |> Enum.find(fn {_parent, children} -> Enum.member?(children, node) end) do
      nil -> ancestor_list
      {parent, _children} -> ancestry([node | ancestor_list], parent, tree)
    end
  end

  def to_distance_map(orbit_tree) do
    get_distance(%{"COM" => 0}, "COM", orbit_tree)
  end

  def get_distance(distance_map, parent, orbit_tree) do
    orbit_tree
    |> Map.get(parent, [])
    |> Enum.reduce(distance_map, fn child, acc ->
      Map.put(acc, child, Map.get(acc, parent) + 1)
      |> get_distance(child, orbit_tree)
    end)
  end

  def to_tree(orbits) do
    orbits
    |> Enum.reduce(Map.new(), fn [parent_body, satellite], acc ->
      acc |> Map.update(parent_body, [satellite], fn satellites -> [satellite | satellites] end)
    end)
  end

  def orbits() do
    Advent.input_lines(2019, 6)
    |> Stream.map(&String.split(&1, ")"))
  end
end
