// Tile the map 5x5, raising risk by tile distance and wrapping 9 -> 1, then rerun Dijkstra.
static class Part2
{
    public static int[,] Tile(int[,] risk, int times)
    {
        int rows = risk.GetLength(0), cols = risk.GetLength(1);
        var big = new int[rows * times, cols * times];
        foreach (var (r, c) in Part1.Cells(rows * times, cols * times))
            big[r, c] = (risk[r % rows, c % cols] + r / rows + c / cols - 1) % 9 + 1;
        return big;
    }

    public static object Solve(string input) => Part1.LowestRisk(Tile(Part1.Parse(input), 5));
}
