// Rank hands with LINQ OrderBy(type).ThenBy(card 1)...ThenBy(card 5). A hand's type is
// its group sizes, largest first, ranked by a lookup on the string form ("32" = full house).
record Hand(string Cards, long Bid);

static class Part1
{
    static readonly string[] Shapes = ["11111", "2111", "221", "311", "32", "41", "5"];

    public static List<Hand> Parse(string input) =>
        input.Split('\n', StringSplitOptions.RemoveEmptyEntries)
            .Select(line => line.Split(' '))
            .Select(p => new Hand(p[0], long.Parse(p[1])))
            .ToList();

    public static List<int> Shape(string cards) =>
        cards.GroupBy(c => c).Select(g => g.Count()).OrderDescending().ToList();

    public static int TypeRank(List<int> shape) => Array.IndexOf(Shapes, string.Concat(shape));

    public static long Winnings(List<Hand> hands, Func<string, List<int>> shapeOf, string order)
    {
        var sorted = hands.OrderBy(h => TypeRank(shapeOf(h.Cards)));
        for (var i = 0; i < 5; i++)
        {
            var at = i;
            sorted = sorted.ThenBy(h => order.IndexOf(h.Cards[at]));
        }
        return sorted.Select((h, rank) => h.Bid * (rank + 1)).Sum();
    }

    public static object Solve(string input) => Winnings(Parse(input), Shape, "23456789TJQKA");
}
