// Same backwards BFS from E; stop at the first square of elevation 'a'.
module part2;

import part1 : Heightmap;

auto solve(string input) {
    auto h = Heightmap.parse(input);
    return h.stepsFromEnd(p => h.grid[p.r][p.c] == 'a');
}
