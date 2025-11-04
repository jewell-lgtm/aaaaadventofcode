import { solve as knotHash } from "../day10/part2";

interface Coordinate {
  ___useMemoizedConstructorPlease: Symbol;
  y: number;
  x: number;
}

export function solve(input: string): number | string {
  const values = Array.from({ length: 128 }, (_, i) => `${input.trim()}-${i}`);
  const hashed = values.map((it) => knotHash(it));
  const grid = hashed.map((hash) => hexToBinary(hash));

  const allOnes = new Set<Coordinate>();
  for (let y = 0; y < grid.length; y++) {
    for (let x = 0; x < grid[y].length; x++) {
      if (grid[y][x] === "1") {
        allOnes.add(coordinate({ x, y }));
      }
    }
  }

  const searchSpace = new Set<Coordinate>(allOnes.values());
  const seen = new Set<Coordinate>();
  let groups = 0;

  while (searchSpace.size) {
    const start = searchSpace.values().next().value!!;

    console.log(`new group starting at ${str(start)}`);
    groups++;

    const toCheck = new Set([start]);

    while (toCheck.size) {
      const next = pop(toCheck);
      if (seen.has(next)) continue;
      seen.add(next);
      searchSpace.delete(next);
      for (const neighbor of neighbors(next)) {
        if (allOnes.has(neighbor)) {
          toCheck.add(neighbor);
        }
      }
    }
  }

  return groups;
}

function hexToBinary(hex: string): string {
  let binary = "";

  for (let i = 0; i < hex.length; i++) {
    const hexDigit = hex[i];
    const decimal = parseInt(hexDigit, 16);
    const binaryDigit = decimal.toString(2).padStart(4, "0");
    binary += binaryDigit;
  }

  return binary;
}

// means we can check by identity
const memo = new Map<string, Coordinate>();
const secretSymbol = Symbol();
function coordinate({ x, y }: { x: number; y: number }): Coordinate {
  const key = `x:${x},y:${y}`;
  if (!memo.has(key)) {
    memo.set(key, { ___useMemoizedConstructorPlease: secretSymbol, x, y });
  }

  return memo.get(key)!!;
}

// dont bother bounds checking
function neighbors(pos: Coordinate): Coordinate[] {
  return [
    [-1, 0], // up
    [0, -1], // left
    [0, 1], // right
    [1, 0], // down
  ].map(([dx, dy]) => coordinate({ x: pos.x + dx, y: pos.y + dy }));
}

function str({ x, y }: Coordinate): string {
  return `${x},${y}`;
}

function pop<T>(set: Set<T>): T {
  if (set.size === 0) {
    throw new Error("empty set");
  }
  const value = set.values().next().value!!;
  set.delete(value);
  return value;
}
