// Forty steps: the pair counts stay small, so the same code just runs longer.
class Part2 {
    static Object solve(String input) {
        return Part1.spread(Part1.parse(input), 40);
    }
}
