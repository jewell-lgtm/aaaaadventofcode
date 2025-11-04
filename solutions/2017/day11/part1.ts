import assert from "assert";

export function solve(input: string): number | string {
  const steps = input.trim().split(",") as Direction[];
  const end = steps.reduce<Position>((pos, it) => step(pos, it), {
    q: 0,
    r: 0,
    s: 0,
  });
  return distance(end);
}

interface Position {
  q: number;
  r: number;
  s: number;
}

const directions = {
  n: [0, -1, 1],
  ne: [1, -1, 0],
  se: [1, 0, -1],
  s: [0, 1, -1],
  sw: [-1, 1, 0],
  nw: [-1, 0, 1],
} as const;

type Direction = keyof typeof directions;

// mutates and returns. fight me.
function step(pos: Position, dir: string): Position {
  const direction = directions[dir as Direction];
  assert(direction, `Direction ${dir} is invalid`);
  const [q, r, s] = direction;
  pos.q += q;
  pos.r += r;
  pos.s += s;
  return pos;
}

function distance(pos: Position) {
  return (Math.abs(pos.q) + Math.abs(pos.r) + Math.abs(pos.s)) / 2;
}
