// Same Dijkstra; the 5×5 tiled map is computed on the fly by a nested function.
module part2;

import part1 : lowestTotalRisk;

auto solve(string input) {
    return lowestTotalRisk(input, 5);
}
