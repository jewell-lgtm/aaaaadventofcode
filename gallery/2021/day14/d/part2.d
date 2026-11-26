// 40 steps would build ~20 trillion elements; the pair counts don't care.
module part2;

import part1 : polymerStrength;

auto solve(string input) {
    return polymerStrength(input, 40);
}
