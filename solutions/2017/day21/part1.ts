export function solve(input: string): number | string {
  const rules = input
    .trim()
    .split("\n")
    .map((it) => it.split(" => "));
  console.log(rules[0]);
  const begin = ".#.\n..#\n###".split("\n");

  const rulesMap = new Map<string, string>();
  for (const [from, to] of rules) {
    for (const shouldFlip of [false, true]) {
      for (const rotations of [0, 1, 2, 3]) {
        let key = from;
        if (shouldFlip) {
          key = flip(key.split("/")).join("/");
        }
        for (let r = 0; r < rotations; r++) {
          key = rotate(key.split("/")).join("/");
        }
        rulesMap.set(key, to);
      }
    }
  }

  const squares = readSquares(begin);

  console.log(squares);

  // Your solution here

  return 0;
}

// I get the feeling we'll do this a lot
const memoRotate = new Map<string, string[]>();
function rotate(pattern: string[]): string[] {
  if (memoRotate.has(pattern.join("\n"))) {
    return memoRotate.get(pattern.join("\n"))!;
  }

  const chars = pattern.map((line) => line.split(""));
  const result = Array.from({ length: chars[0].length }, () =>
    Array.from({ length: chars.length }, () => ""),
  );

  /**
   * 00 01 02    20 10 00
   * 10 11 12    21 11 01
   * 20 21 22 => 22 12 02 */

  for (let r = 0; r < chars.length; r++) {
    for (let c = 0; c < chars[0].length; c++) {
      result[c][chars.length - 1 - r] = chars[r][c];
    }
  }

  memoRotate.set(
    pattern.join("\n"),
    result.map((line) => line.join("")),
  );
  return result.map((line) => line.join(""));
}

const memoFlip = new Map<string, string[]>();
function flip(pattern: string[]): string[] {
  if (memoFlip.has(pattern.join("\n"))) {
    return memoFlip.get(pattern.join("\n"))!;
  }
  const result = pattern.map((line) => line.split("").reverse().join(""));
  memoFlip.set(pattern.join("\n"), result);
  return result;
}

function readSquares(grid: string[]): string[] {
  if (grid.length % 2 === 0) {
    throw new Error("TODO!");
  } else if (grid.length % 3 === 0) {
    const actualSize = grid.length * grid.length;
    const nGrids = actualSize / 9;

    const squares = [] as string[][][];
    for (let i = 0; i < nGrids; i++) {
      squares[i] = Array.from({ length: 3 }, () =>
        Array.from({ length: 3 }, () => ""),
      );
      for (let y = 0; y < 3; y++) {
        for (let x = 0; x < 3; x++) {
          const offsetY = i * 3;
          const offsetX = i * 3;
          squares[i][y][x] = grid[offsetY + y][offsetX + x];
        }
      }
    }

    return squares.map((sq) => sq.join("/"));
  }

  throw new Error("TODO");
}
