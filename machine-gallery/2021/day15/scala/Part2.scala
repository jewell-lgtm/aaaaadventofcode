// The full cave is a 5x5 tiling with risk raised per tile and wrapped 9 -> 1,
// expressed as a new risk function over the original grid.
object Part2:
  def tiled(cave: Part1.Cave, times: Int): Part1.Cave =
    import cave.*
    Part1.Cave(rows * times, cols * times, (r, c) => (risk(r % rows, c % cols) + r / rows + c / cols - 1) % 9 + 1)

  def solve(input: String): Any = Part1.lowestRisk(tiled(Part1.parse(input), 5))
