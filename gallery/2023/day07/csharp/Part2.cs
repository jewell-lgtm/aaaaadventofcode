// Jokers join the biggest real group (list patterns split off the head); J is weakest.
static class Part2
{
    static List<int> JokerShape(string cards)
    {
        var jokers = cards.Count(c => c == 'J');
        return Part1.Shape(cards.Replace("J", "")) switch
        {
            [var top, .. var rest] => [top + jokers, .. rest],
            [] => [jokers],
        };
    }

    public static object Solve(string input) => Part1.Winnings(Part1.Parse(input), JokerShape, "J23456789TQKA");
}
