export function solve(input: string): number | string {
  const tape = input
    .trim()
    .split(/\s+/)
    .map((it) => parseInt(it, 10));

  let pos = 0;
  let count = 0;

  while (pos >= 0 && pos < tape.length) {
    count++;

    const jump = tape[pos];
    if (jump >= 3) {
      tape[pos] -= 1;
    } else {
      tape[pos] += 1;
    }
    pos += jump;
  }

  return count;
}
