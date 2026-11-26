// Jokers: J is the weakest card for ties but joins the largest group when typing a hand.
module part2;

import part1 : totalWinnings;

auto solve(string input) {
    return totalWinnings(input, "J23456789TQKA", true);
}
