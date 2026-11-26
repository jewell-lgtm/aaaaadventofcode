// Shared parser: the crate drawing is read column-wise (letters sit at 1, 5, 9, ...).
export type Move = { count: number; from: number; to: number };

export function parse(input: string): { stacks: string[][]; moves: Move[] } {
  const [drawing, procedure] = input.trimEnd().split("\n\n");
  const rows = drawing.split("\n").slice(0, -1).reverse(); // bottom row first, drop the labels
  const width = Math.ceil(Math.max(...rows.map((r) => r.length)) / 4);
  const stacks = Array.from({ length: width }, (_, i) =>
    rows.map((row) => row[1 + 4 * i]).filter((c) => c && c !== " "),
  );
  const moves = [...procedure.matchAll(/move (\d+) from (\d+) to (\d+)/g)].map(([, n, f, t]) => ({
    count: +n,
    from: +f - 1,
    to: +t - 1,
  }));
  return { stacks, moves };
}

export const tops = (stacks: string[][]) => stacks.map((s) => s.at(-1) ?? "").join("");
