# "humn" is the unknown. Walk down from root along the side that depends on humn,
# inverting each operation against the other side's constant value.
defmodule Part2 do
  import Part1, only: [parse: 1, eval: 2]

  def solve(input) do
    jobs = parse(input)
    {_op, a, b} = jobs["root"]

    if humn?(jobs, a),
      do: solve_for(jobs, a, eval(jobs, b)),
      else: solve_for(jobs, b, eval(jobs, a))
  end

  defp humn?(_jobs, "humn"), do: true

  defp humn?(jobs, name) do
    case jobs[name] do
      {_op, a, b} -> humn?(jobs, a) or humn?(jobs, b)
      _n -> false
    end
  end

  # the value humn must take for `name` to evaluate to `target`
  defp solve_for(_jobs, "humn", target), do: target

  defp solve_for(jobs, name, target) do
    {op, a, b} = jobs[name]

    if humn?(jobs, a),
      do: solve_for(jobs, a, invert_left(op, target, eval(jobs, b))),
      else: solve_for(jobs, b, invert_right(op, target, eval(jobs, a)))
  end

  # target = x op v
  defp invert_left("+", t, v), do: t - v
  defp invert_left("-", t, v), do: t + v
  defp invert_left("*", t, v), do: div(t, v)
  defp invert_left("/", t, v), do: t * v

  # target = v op x
  defp invert_right("+", t, v), do: t - v
  defp invert_right("-", t, v), do: v - t
  defp invert_right("*", t, v), do: div(t, v)
  defp invert_right("/", t, v), do: div(v, t)
end
