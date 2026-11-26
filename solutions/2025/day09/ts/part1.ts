export function solve(input: string): number | string {
  const points = input
    .trim()
    .split("\n")
    .map((line) => line.split(",").map(Number) as [number, number]);

  let max = 0;
  for (const [a, b] of getPairs(points)) {
    max = Math.max(max, area(a, b));
  }

  return max;
}

function area(a: [number, number], b: [number, number]): number {
  const width = Math.abs(b[0] - a[0]) + 1;
  const height = Math.abs(b[1] - a[1]) + 1;
  return width * height;
}

function* getPairs(
  points: [number, number][],
): Generator<[[number, number], [number, number]]> {
  for (let i = 0; i < points.length; i++) {
    for (let j = i + 1; j < points.length; j++) {
      yield [points[i], points[j]];
    }
  }
}
