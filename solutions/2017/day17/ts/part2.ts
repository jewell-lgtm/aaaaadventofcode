import assert from "assert";
export function solve(input: string): number | string {
  const stepSize = parseInt(input.trim(), 10);

  let result: number;
  let pos = 0;

  for (let i = 1; i <= 50_000_000; i++) {
    pos = (pos + stepSize) % i;

    if (pos === 0) {
      result = i;
    }

    pos = pos + 1;
  }

  assert(result!);

  return result;
}
