export function solve(input: string): number | string {
  const points = input
    .trim()
    .split("\n")
    .map((line) => line.split(",").map(Number) as [number, number])
    .toSorted((a, b) => a[0] * a[1] - (b[0] - b[1]));

  let max = 0;

  let minY = Infinity;
  let maxY = -Infinity;
  let minX = Infinity;
  let maxX = -Infinity;

  for (const [x, y] of points) {
    minY = Math.min(minY, y);
    maxY = Math.max(maxY, y);
    minX = Math.min(minX, x);
    maxX = Math.max(maxX, x);
  }

  const svg = `
<svg xmlns="http://www.w3.org/2000/svg" viewBox="${minX - 1} ${minY - 1} ${maxX - minX + 3} ${maxY - minY + 3}" width="${(maxX - minX + 3) * 10}" height="${(maxY - minY + 3) * 10}">
<polygon points=${toSvgPoints(points)} fill="lightgray" stroke="black" stroke-width="0.1"/>
</svg>
`;

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

function key(val: [number, number]): string {
  return val.join(",");
}

function toSvgPoints(points: [number, number][]): string {
  let result: string[] = [];
  const start = points[0];
  result.push(toSvgPoint(start));
  let next = getNext(points, start);
  while (next !== start) {
    result.push(toSvgPoint(next));
    next = getNext(points, next);
  }

  console.log(result);

  return result.join(" ");
}

function toSvgPoint([x, y]: [number, number]): string {
  return `${x},${y}`;
}

function getNext(
  points: [number, number][],
  current: [number, number],
): [number, number] {
  const up = points
    .filter(([x, y]) => x === current[0] && y < current[1])
    .toSorted((a, b) => a[1] - b[1]);
  if (up.length) return up[up.length - 1];
  const right = points
    .filter(([x, y]) => y === current[1] && x > current[0])
    .toSorted((a, b) => a[0] - b[0]);
  if (right.length) return right[0];
  const down = points
    .filter(([x, y]) => x === current[0] && y > current[1])
    .toSorted((a, b) => a[1] - b[1]);
  if (down.length) return down[0];
  const left = points
    .filter(([x, y]) => y === current[1] && x < current[0])
    .toSorted((a, b) => a[0] - b[0]);
  if (left.length) return left[left.length - 1];
  throw new Error("No next point found");
}
