// humn is the unknown. Walk from root down the side that depends on humn, inverting
// each operation against the constant side's value.
static class Part2
{
    const string Human = "humn";

    static bool DependsOnHuman(Dictionary<string, Job> jobs, string name) =>
        name == Human || jobs[name] is Op(var l, _, var r) && (DependsOnHuman(jobs, l) || DependsOnHuman(jobs, r));

    /// <summary>The value humn must shout so that monkey <paramref name="name"/> yields target.</summary>
    static long SolveFor(Dictionary<string, Job> jobs, string name, long target)
    {
        if (name == Human) return target;
        var (l, op, r) = (Op)jobs[name];
        if (DependsOnHuman(jobs, l))
        {
            var v = Part1.Eval(jobs, r); // target = x op v
            return SolveFor(jobs, l, op switch { '+' => target - v, '-' => target + v, '*' => target / v, _ => target * v });
        }
        var w = Part1.Eval(jobs, l);     // target = w op x
        return SolveFor(jobs, r, op switch { '+' => target - w, '-' => w - target, '*' => target / w, _ => w / target });
    }

    public static object Solve(string input)
    {
        var jobs = Part1.Parse(input);
        var (l, _, r) = (Op)jobs["root"];
        return DependsOnHuman(jobs, l) ? SolveFor(jobs, l, Part1.Eval(jobs, r)) : SolveFor(jobs, r, Part1.Eval(jobs, l));
    }
}
