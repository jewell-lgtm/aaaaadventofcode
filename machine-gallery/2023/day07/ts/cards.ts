// Shared: a hand's sort key is [its sorted group sizes, its card ranks]; compared element-wise.
export type Rules = { order: string; jokers: boolean };

function shape(hand: string, jokers: boolean): number[] {
  const counts = new Map<string, number>();
  for (const c of hand) counts.set(c, (counts.get(c) ?? 0) + 1);
  const wild = jokers ? (counts.get("J") ?? 0) : 0;
  if (jokers) counts.delete("J");
  const groups = [...counts.values()].sort((a, b) => b - a);
  groups[0] = (groups[0] ?? 0) + wild; // jokers join the biggest group
  return groups;
}

function compareKeys(a: number[], b: number[]): number {
  for (let i = 0; i < Math.max(a.length, b.length); i++) {
    const d = (a[i] ?? 0) - (b[i] ?? 0);
    if (d) return d;
  }
  return 0;
}

export function winnings(input: string, { order, jokers }: Rules): number {
  const hands = input.trimEnd().split("\n").map((line) => {
    const [hand, bid] = line.split(" ");
    return { shape: shape(hand, jokers), ranks: [...hand].map((c) => order.indexOf(c)), bid: +bid };
  });
  hands.sort((a, b) => compareKeys(a.shape, b.shape) || compareKeys(a.ranks, b.ranks));
  return hands.reduce((sum, h, i) => sum + h.bid * (i + 1), 0);
}
