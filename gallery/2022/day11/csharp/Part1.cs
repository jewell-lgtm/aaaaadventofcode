// Monkeys parsed with one regex per block into a class holding a Queue<long> of items
// and a Func<long, long> operation; the simulation mutates them in place.
using System.Text.RegularExpressions;

class Monkey(IEnumerable<long> items, Func<long, long> op, long divisor, int ifTrue, int ifFalse)
{
    public Queue<long> Items { get; } = new(items);
    public Func<long, long> Op => op;
    public long Divisor => divisor;
    public long Inspected { get; set; }
    public int Target(long worry) => worry % divisor == 0 ? ifTrue : ifFalse;
}

static partial class Part1
{
    [GeneratedRegex(@"Monkey \d+:\s+Starting items: ([\d, ]*)\s+Operation: new = old ([*+]) (\w+)\s+Test: divisible by (\d+)\s+If true: throw to monkey (\d+)\s+If false: throw to monkey (\d+)")]
    private static partial Regex Block();

    static Func<long, long> Operation(string op, string operand) => (op, long.TryParse(operand, out var n)) switch
    {
        ("*", true) => old => old * n,
        ("*", false) => old => old * old,
        (_, true) => old => old + n,
        (_, false) => old => old + old,
    };

    public static List<Monkey> Parse(string input) =>
        Block().Matches(input).Select(m => new Monkey(
            m.Groups[1].Value.Split(", ").Select(long.Parse),
            Operation(m.Groups[2].Value, m.Groups[3].Value),
            long.Parse(m.Groups[4].Value), int.Parse(m.Groups[5].Value), int.Parse(m.Groups[6].Value))).ToList();

    public static long MonkeyBusiness(List<Monkey> monkeys, int rounds, Func<long, long> relief)
    {
        for (var round = 0; round < rounds; round++)
            foreach (var m in monkeys)
                while (m.Items.TryDequeue(out var old))
                {
                    var worry = relief(m.Op(old));
                    monkeys[m.Target(worry)].Items.Enqueue(worry);
                    m.Inspected++;
                }
        return monkeys.Select(m => m.Inspected).OrderDescending().Take(2).Aggregate((a, b) => a * b);
    }

    public static object Solve(string input) => MonkeyBusiness(Parse(input), 20, w => w / 3);
}
