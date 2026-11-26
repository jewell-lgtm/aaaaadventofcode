// Shared: count arrangements with a memoised recursion over (position in row, groups placed).
export function arrangements(row: string, groups: number[]): number {
  const memo = new Map<number, number>();
  const count = (i: number, g: number): number => {
    if (i >= row.length) return g === groups.length ? 1 : 0;
    const key = i * 100 + g;
    if (memo.has(key)) return memo.get(key)!;
    let total = 0;
    if (row[i] !== "#") total += count(i + 1, g); // treat as operational
    const size = groups[g];
    if (row[i] !== "." && g < groups.length && fits(i, size)) total += count(i + size + 1, g + 1);
    memo.set(key, total);
    return total;
  };
  // A damaged run of `size` can start at i: no '.' inside and not followed by '#'.
  const fits = (i: number, size: number) =>
    i + size <= row.length && !row.slice(i, i + size).includes(".") && row[i + size] !== "#";
  return count(0, 0);
}

export function parse(input: string, copies: number) {
  return input.trimEnd().split("\n").map((line) => {
    const [row, groups] = line.split(" ");
    return {
      row: Array(copies).fill(row).join("?"),
      groups: Array(copies).fill(groups).join(",").split(",").map(Number),
    };
  });
}

export const totalArrangements = (input: string, copies: number) =>
  parse(input, copies).reduce((sum, { row, groups }) => sum + arrangements(row, groups), 0);
