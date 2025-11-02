export function solve(input: string): number | string {
  const digits = input
    .trim()
    .split("")
    .map((it) => parseInt(it, 10));

  let result = 0;
  for (let i = 0; i < digits.length; i++) {
    const first = digits[i];
    const second = digits[(i + 1) % digits.length];

    if (first === second) {
      result += first;
    }
  }

  return result;
}
