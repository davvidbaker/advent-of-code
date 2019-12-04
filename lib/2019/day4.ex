defmodule Advent201904 do
  def run do
    # IO.inspect(part1())
    IO.inspect(part2())
  end

  defp part1 do
    my_range()
    |> Enum.reduce(0, fn password, count ->
      if is_valid?(Integer.to_string(password)), do: count + 1, else: count
    end)
  end

  defp part2 do
    my_range()
    |> Enum.reduce(0, fn password, count ->
      if is_actually_valid?(Integer.to_string(password)), do: count + 1, else: count
    end)
  end

  defp is_valid?(password) do
    if two_adjacents_are_same?(password) do
      digits_never_decrease?(to_digits(password))
    else
      false
    end
  end

  defp is_actually_valid?(password) do
    if two_adjacents_are_same_with_caveat?(password) do
      digits_never_decrease?(to_digits(password))
    else
      false
    end
  end

  defp digits_never_decrease?([d1, d2, d3, d4, d5, d6]) do
    d1 <= d2 && d2 <= d3 && d3 <= d4 && d4 <= d5 && d5 <= d6
  end

  defp two_adjacents_are_same?(str) do
    Regex.match?(~r/(.)\1+/, str)
  end

  defp two_adjacents_are_same_with_caveat?(str) do
    if two_adjacents_are_same?(str) do
      meets_criteria?(str |> to_digits)
    else
      false
    end
  end

  defp meets_criteria?(digits) do
    digits
    |> Enum.reduce(
      %{
        0 => 0,
        1 => 0,
        2 => 0,
        3 => 0,
        4 => 0,
        5 => 0,
        6 => 0,
        7 => 0,
        8 => 0,
        9 => 0
      },
      fn digit, digit_map -> Map.update(digit_map, digit, 1, &(&1 + 1)) end
    )
    |> Map.values()
    |> Enum.find_value(fn x -> x == 2 end)
  end

  defp to_digits(str) do
    str |> String.codepoints() |> Enum.map(&String.to_integer/1)
  end

  defp my_range do
    124_075..580_769
  end
end
