export function solve(input: string): number | string {
  const grid = input
    .trim()
    .split("\n")
    .map((line) => line.split(""));

  let result = 0;
  let active = true;

  while (active) {
    let generation = 0;
    for (let y = 0; y < grid.length; y++) {
      const line = grid[y];
      for (let x = 0; x < line.length; x++) {
        const char = line[x];
        if (char === "@") {
          let count = 0;
          for (const neighbor of neighbors(y, x)) {
            if (neighbor === "@") {
              count += 1;
            }
          }
          if (count < 4) {
            generation += 1;
            grid[y][x] = ".";
          }
        }
      }
    }
    result += generation;
    active = generation > 0;
  }

  function neighbors(y: number, x: number): string[] {
    return [
      [-1, -1],
      [-1, 0],
      [-1, 1],
      [0, -1],
      [0, 1],
      [1, -1],
      [1, 0],
      [1, 1],
    ]
      .map(([dy, dx]) => {
        if (grid[y + dy] && grid[y + dy][x + dx]) {
          return grid[y + dy][x + dx];
        }
      })
      .filter((it) => it != null);
  }

  return result;
}
