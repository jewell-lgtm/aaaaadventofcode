export function solve(input: string): number | string {
  const grid = input.trim().split("\n");

  let split = 0;
  let beams = new Set<string>();
  beams.add(key(locate(grid, "S")));
  let y = locate(grid, "S")[1] + 1;

  console.log(y);

  while (y < grid.length) {
    const oldBeams = Array.from(beams).map(
      (it) => it.split(",").map(Number) as [number, number],
    );
    for (const old of beams) {
      beams.delete(old);
    }
    for (const [x, _] of oldBeams) {
      if (x < 0 || x >= grid[0].length) continue;
      if (grid[y][x] === ".") {
        beams.add(key([x, y + 1]));
      } else if (grid[y][x] === "^") {
        beams.add(key([x - 1, y + 1]));
        beams.add(key([x + 1, y + 1]));
        split++;
      } else {
        throw new Error(`Unknown grid cell: ${grid[y][x]}`);
      }
    }
    y++;
  }

  return split;
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

function key([x, y]: [number, number]): string {
  return `${x},${y}`;
}
