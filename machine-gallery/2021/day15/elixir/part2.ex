# Tile the cave 5x5: every tile step adds 1 to the risk, wrapping 9 back to 1.
defmodule Part2 do
  def tile(%{rows: h, cols: w, risk: risk}) do
    %{
      rows: 5 * h,
      cols: 5 * w,
      risk: fn {r, c} -> rem(risk.({rem(r, h), rem(c, w)}) + div(r, h) + div(c, w) - 1, 9) + 1 end
    }
  end

  def solve(input), do: input |> Part1.parse() |> tile() |> Part1.lowest_risk()
end
