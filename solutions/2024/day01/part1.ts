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

  leftList.sort();
  rightList.sort();

  assert.equal(leftList.length, rightList.length);

  let result = 0;

  for (let i = 0; i < leftList.length; i++) {
    const lo = Math.min(leftList[i], rightList[i]);
    const hi = Math.max(leftList[i], rightList[i]);
    const diff = hi - lo;

    result += diff;
  }

  return result;
}
