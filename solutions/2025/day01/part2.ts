export function solve(input: string): number | string {
  const lines = input.trim().split("\n");

  const rotations = lines.map((it) => toInt(it));

  let value = 50;
  let password = 0;

  for (const rotation of rotations) {
    for (const i of countTo(rotation)) {
      value = (100 + (value + i)) % 100;
      if (value === 0) {
        password += 1;
      }
    }
  }

  return password;
}

function toInt(line: string) {
  return parseInt(line.replace("L", "-").replace("R", "+"), 10);
}

function countTo(n: number) {
  const sign = n < 0 ? -1 : 1;
  return Array.from({ length: Math.abs(n) }, (_) => sign);
}
