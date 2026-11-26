// Jobs as a small record hierarchy (Num | Op); evaluation is a recursive switch
// expression with type and property patterns.
abstract record Job;
record Num(long Value) : Job;
record Op(string Left, char Operator, string Right) : Job;

static class Part1
{
    public static Dictionary<string, Job> Parse(string input) =>
        input.Split('\n', StringSplitOptions.RemoveEmptyEntries)
            .Select(line => line.Split(": "))
            .ToDictionary(p => p[0], p => p[1].Split(' ') switch
            {
                [var n] => (Job)new Num(long.Parse(n)),
                [var l, var op, var r] => new Op(l, op[0], r),
                _ => throw new FormatException(p[1]),
            });

    public static long Eval(Dictionary<string, Job> jobs, string name) => jobs[name] switch
    {
        Num(var v) => v,
        Op(var l, '+', var r) => Eval(jobs, l) + Eval(jobs, r),
        Op(var l, '-', var r) => Eval(jobs, l) - Eval(jobs, r),
        Op(var l, '*', var r) => Eval(jobs, l) * Eval(jobs, r),
        Op(var l, '/', var r) => Eval(jobs, l) / Eval(jobs, r),
        var job => throw new InvalidOperationException($"{job}"),
    };

    public static object Solve(string input) => Eval(Parse(input), "root");
}
