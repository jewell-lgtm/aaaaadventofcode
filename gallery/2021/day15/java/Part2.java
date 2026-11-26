// Tile the map 5x5, each tile's risk raised by its tile distance and wrapped 9 -> 1,
// then run part 1's Dijkstra on the bigger grid.
class Part2 {
    static int[][] tile(int[][] risk, int times) {
        int rows = risk.length, cols = risk[0].length;
        var big = new int[rows * times][cols * times];
        for (int r = 0; r < big.length; r++)
            for (int c = 0; c < big[0].length; c++)
                big[r][c] = (risk[r % rows][c % cols] + r / rows + c / cols - 1) % 9 + 1;
        return big;
    }

    static Object solve(String input) {
        return Part1.lowestRisk(tile(Part1.parse(input), 5));
    }
}
