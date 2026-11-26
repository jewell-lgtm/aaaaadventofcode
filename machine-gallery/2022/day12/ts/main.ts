// Harness entry: don't edit. stdin = input, AOC_PART = 1|2, prints the answer last.
const part = process.env.AOC_PART === "2" ? 2 : 1;
const input = await Bun.stdin.text();
const { solve } = await import(part === 2 ? "./part2.ts" : "./part1.ts");
console.log(String(await solve(input)));
