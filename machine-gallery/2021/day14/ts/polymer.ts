// Shared: never build the string. Track counts of adjacent pairs; each rule AB -> C turns
// every AB into AC + CB. Element counts are the first letter of each pair, plus the last letter.
function add<K>(m: Map<K, number>, k: K, n: number) {
  m.set(k, (m.get(k) ?? 0) + n);
}

export function polymerSpread(input: string, steps: number): number {
  const [template, rulesBlock] = input.trim().split("\n\n");
  const rules = new Map(rulesBlock.split("\n").map((l) => l.split(" -> ") as [string, string]));

  let pairs = new Map<string, number>();
  for (let i = 0; i + 1 < template.length; i++) add(pairs, template.slice(i, i + 2), 1);

  for (let s = 0; s < steps; s++) {
    const next = new Map<string, number>();
    for (const [pair, n] of pairs) {
      const c = rules.get(pair);
      if (c === undefined) add(next, pair, n);
      else (add(next, pair[0] + c, n), add(next, c + pair[1], n));
    }
    pairs = next;
  }

  const elements = new Map<string, number>([[template.at(-1)!, 1]]);
  for (const [pair, n] of pairs) add(elements, pair[0], n);
  const counts = [...elements.values()];
  return Math.max(...counts) - Math.min(...counts);
}
