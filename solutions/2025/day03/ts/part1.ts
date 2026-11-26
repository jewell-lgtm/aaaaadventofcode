export function solve(input: string): number | string {
  const lines = input.trim().split("\n");

  let result = 0;
  for (const line of lines) {
    let maxJoltage = -Infinity;
    for (let i = line.length - 2; i >= 0; i--) {
      for (let j = i + 1; j < line.length; j++) {
        const left = line[i];
        const right = line[j];
        maxJoltage = Math.max(maxJoltage, parseInt(left + right));
      }
    }
    result += maxJoltage;
  }

  return result;
}
