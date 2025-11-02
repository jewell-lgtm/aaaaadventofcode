import assert from "assert";

export function solve(input: string): number | string {
  const lines = input.trim().split("\n");

  const leftList: number[] = [];
  const rightList: number[] = [];

  for (const line of lines) {
    const [left, right] = line.split(/\s+/);
    leftList.push(parseInt(left, 10));
    rightList.push(parseInt(right, 10));
  }

  assert.equal(leftList.length, rightList.length);

  const freq = new Map<number, number>();

  for (const n of rightList) {
    if (!freq.has(n)) {
      freq.set(n, 0);
    }
    freq.set(n, freq.get(n)! + 1);
  }

  let result = 0;

  for (const n of leftList) {
    result += n * (freq.get(n) ?? 0);
  }

  return result;
}
