# Monkey Math: each monkey is an integer or an {op, left, right} tuple in a map;
# `eval` recurses with one function clause per shape.
defmodule Part1 do
  def parse(input) do
    for line <- String.split(input, "\n", trim: true), into: %{} do
      [name, job] = String.split(line, ": ")

      case String.split(job) do
        [left, op, right] -> {name, {op, left, right}}
        [n] -> {name, String.to_integer(n)}
      end
    end
  end

  def eval(jobs, name), do: calc(jobs, jobs[name])

  defp calc(_jobs, n) when is_integer(n), do: n
  defp calc(jobs, {op, a, b}), do: apply_op(op, eval(jobs, a), eval(jobs, b))

  defp apply_op("+", a, b), do: a + b
  defp apply_op("-", a, b), do: a - b
  defp apply_op("*", a, b), do: a * b
  defp apply_op("/", a, b), do: div(a, b)

  def solve(input), do: input |> parse() |> eval("root")
end
