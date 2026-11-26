// Same backwards BFS from E; stop at the first square of height 'a'.
class Part2 {
    static Object solve(String input) {
        var hill = Part1.parse(input);
        return Part1.stepsFromEnd(hill, p -> hill.height(p) == 'a');
    }
}
