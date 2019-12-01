defmodule Advent do
  def input_file(year, day) do
    Path.join([
      Path.expand("../../../../test", Application.app_dir(:advent)),
      "#{year}",
      "day#{day}.in"
    ])
  end

  def input_lines(year, day) do
    input_file(year, day)
    |> File.stream!()
    |> Stream.map(&String.trim/1)
  end
end
