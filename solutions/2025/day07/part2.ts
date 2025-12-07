export function solve(input: string): number | string {
  const grid = input.trim().split("\n");
  const start = locate(grid, "S")[0];
  let y = locate(grid, "S")[1] + 1;

  const beams = new Map<number, bigint>();

  beams.set(start, 1n);

  while (y < grid.length) {
    const nextBeams: bigint[] = [];

    for (let i = 0; i < grid[0].length; i++) {
      const numBeams = beams.get(i) ?? 0n;
      if (grid[y][i] === ".") {
        nextBeams[i] = (nextBeams[i] ?? 0n) + numBeams;
      } else if (grid[y][i] === "^") {
        nextBeams[i - 1] = (nextBeams[i - 1] ?? 0n) + numBeams;
        nextBeams[i + 1] = (nextBeams[i + 1] ?? 0n) + numBeams;
      } else {
        throw new Error(`Unknown grid cell: ${grid[y][i]}`);
      }
    }

    for (let i = 0; i < nextBeams.length; i++) {
      beams.set(i, nextBeams[i] ?? 0n);
    }

    y++;
  }

  return sum(Array.from(beams.values())).toString();
}

function locate(grid: string[], target: string): [number, number] {
  for (let y = 0; y < grid.length; y++) {
    for (let x = 0; x < grid[y].length; x++) {
      if (grid[y][x] === target) {
        return [x, y];
      }
    }
  }
  throw new Error(`Target ${target} not found in grid`);
}

function sum(xs: bigint[]): bigint {
  return xs.reduce((a, b) => a + b, 0n);
}
