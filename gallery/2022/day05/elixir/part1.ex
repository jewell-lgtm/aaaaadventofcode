# Supply Stacks: pad the drawing rows, pick every 4th character, and zip the rows into
# columns (head = top crate). Moves are destructured with a list pattern and reduced
# over a map of stacks; `crane` decides whether lifted crates flip (9000) or not (9001).
defmodule Part1 do
  def parse_stacks(drawing) do
    [_labels | rows] = drawing |> String.split("\n") |> Enum.reverse()
    width = rows |> Enum.map(&String.length/1) |> Enum.max()

    rows
    |> Enum.reverse()
    |> Enum.map(fn row ->
      row
      |> String.pad_trailing(width)
      |> String.graphemes()
      |> Enum.drop(1)
      |> Enum.take_every(4)
    end)
    |> Enum.zip_with(&Enum.reject(&1, fn crate -> crate == " " end))
    |> Enum.with_index(1)
    |> Map.new(fn {stack, i} -> {i, stack} end)
  end

  def parse_move(line) do
    ["move", n, "from", from, "to", to] = String.split(line)
    Enum.map([n, from, to], &String.to_integer/1)
  end

  def apply_move([n, from, to], stacks, crane) do
    {lifted, rest} = Enum.split(stacks[from], n)
    stacks |> Map.put(from, rest) |> Map.update!(to, &(crane.(lifted) ++ &1))
  end

  def run(input, crane) do
    [drawing, moves] = String.split(input, "\n\n", trim: true)

    moves
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_move/1)
    |> Enum.reduce(parse_stacks(drawing), &apply_move(&1, &2, crane))
    |> Enum.sort()
    |> Enum.map_join(fn {_, stack} -> List.first(stack, "") end)
  end

  def solve(input), do: run(input, &Enum.reverse/1)
end
