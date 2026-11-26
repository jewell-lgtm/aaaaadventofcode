// Harness entry: don't edit. stdin = input, AOC_PART = 1|2, prints the answer last.
var input = Console.In.ReadToEnd();
Console.WriteLine(Environment.GetEnvironmentVariable("AOC_PART") == "2" ? Part2.Solve(input) : Part1.Solve(input));
