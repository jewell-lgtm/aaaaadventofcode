// Shared: Dijkstra with a bucket queue. Edge weights are 1..9, so buckets indexed by
// distance replace a heap: pop from the lowest non-empty bucket.
export function lowestRisk(input: string, tiles: number): number {
  const base = input.trimEnd().split("\n").map((row) => [...row].map(Number));
  const [h, w] = [base.length, base[0].length];
  const [H, W] = [h * tiles, w * tiles];
  const risk = (r: number, c: number) =>
    ((base[r % h][c % w] + Math.floor(r / h) + Math.floor(c / w) - 1) % 9) + 1;

  const dist = new Array<number>(H * W).fill(Infinity);
  const buckets: number[][] = [[0]];
  dist[0] = 0;
  for (let d = 0; d < buckets.length; d++) {
    for (const p of buckets[d] ?? []) {
      if (dist[p] !== d) continue; // stale entry
      const [r, c] = [Math.floor(p / W), p % W];
      if (r === H - 1 && c === W - 1) return d;
      for (const [nr, nc] of [[r + 1, c], [r - 1, c], [r, c + 1], [r, c - 1]]) {
        if (nr < 0 || nc < 0 || nr >= H || nc >= W) continue;
        const nd = d + risk(nr, nc);
        if (nd < dist[nr * W + nc]) {
          dist[nr * W + nc] = nd;
          (buckets[nd] ??= []).push(nr * W + nc);
        }
      }
    }
  }
  throw new Error("unreachable");
}
