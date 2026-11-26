import assert from "assert";

const DIGIT_LENGTH = 12;

export function solve(input: string): number | string {
  const lines = input.trim().split("\n");

  const digitLength = DIGIT_LENGTH;
  let result = BigInt(0);
  for (const line of lines) {
    const positions = Array.from(
      { length: digitLength },
      (_, i) => line.length - digitLength + i,
    );
    function collect(at: number[]) {
      const digits = at.map((it) => line[it]);
      return BigInt(digits.join(""));
    }
    let biggest = collect(positions);
    for (let posI = 0; posI < positions.length; posI++) {
      const min = positions[posI - 1] + 1 || 0;
      const max = positions[posI];
      // move the digit to the left, and slide to the right to see if we can improve it
      positions[posI] = min;
      biggest = collect(positions);
      for (let j = min; j <= max; j++) {
        const guess = positions.map((p, idx) => (idx === posI ? j : p));
        if (collect(guess) > biggest) {
          biggest = collect(guess);
          positions[posI] = j;
        }
      }
    }
    result += biggest;
  }

  assert(result === solveRecursion(input));

  return result.toString();
}

const solveRecursion = (input: string): bigint =>
  sum(lines(input).map((it) => solveLine(digits(it))));

const solveLine = (line: number[]): bigint =>
  collect(line, pickPositions(line, []));

const pickPositions = (line: number[], picked: number[]): number[] =>
  picked.length === DIGIT_LENGTH
    ? picked
    : pickPositions(line, [...picked, nextPosition(line, picked)]);

const nextPosition = (line: number[], picked: number[]): number => {
  const from = last(picked) + 1;
  const remaining = DIGIT_LENGTH - 1 - picked.length;
  const until = line.length - remaining;
  return maxOf(range(from, until), (p) => line[p]);
};

const collect = (line: number[], positions: number[]): bigint =>
  BigInt(positions.map((p) => line[p]).join(""));

const digits = (s: string): number[] =>
  s.split("").map((c) => orPanic(parseInt(c), () => `${c} is not a digit`));

const maxOf = <T>(xs: T[], f: (x: T) => number): T =>
  xs.reduce((a, b) => (f(b) > f(a) ? b : a));

const range = (lo: number, hi: number): number[] =>
  Array.from({ length: hi - lo }, (_, i) => lo + i);

const last = (xs: number[]): number => xs.at(-1) ?? -1;
const sum = (xs: bigint[]): bigint => xs.reduce((a, b) => a + b, 0n);
const lines = (s: string): string[] => s.trim().split("\n");

const orPanic = <T>(value: T | undefined, msg: () => string): T =>
  !!value ? value : raise(msg());

const raise = (msg: string) => {
  throw new Error(msg);
};
