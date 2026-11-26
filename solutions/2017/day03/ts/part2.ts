export function solve(input: string): number | string {
  const target = parseInt(input.trim(), 10);

  const seen = new HashSet<Vec2d>();
  const values = new Map<string, number>();

  values.set("0,0", 1);

  let dirIndex = 0;
  let step = 1;
  let position = new Vec2d(0, 0);
  seen.add(position);

  while (step++ < target) {
    position = position.plus(DIR[directions[dirIndex]]);
    seen.add(position);

    const thisVal = position
      .adjacent()
      .map((it) => values.get(it.toHash()) ?? 0)
      .reduce((a, b) => a + b, 0);
    if (thisVal > target) {
      return thisVal;
    }
    values.set(position.toHash(), thisVal);

    const nextPos = position.plus(DIR[directions[(dirIndex + 1) % 4]]);
    if (!seen.has(nextPos)) {
      dirIndex = (dirIndex + 1) % 4;
    }
  }

  throw new Error("never finished");
}

interface ToHash {
  toHash(): string;
}

class HashSet<T extends ToHash> {
  map = new Map<string, T>();

  has(item: T): boolean {
    return this.map.has(item.toHash());
  }

  add(item: T): void {
    this.map.set(item.toHash(), item);
  }
}

class Vec2d implements ToHash {
  constructor(
    public x: number,
    public y: number,
  ) {}

  toString() {
    return this.toHash();
  }

  toHash(): string {
    return `${this.x},${this.y}`;
  }

  plus(other: Vec2d): Vec2d {
    return new Vec2d(this.x + other.x, this.y + other.y);
  }

  distanceTo(other: Vec2d): number {
    return Math.abs(this.x - other.x) + Math.abs(this.y - other.y);
  }

  adjacent(): Vec2d[] {
    return [
      [-1, -1],
      [0, -1],
      [1, -1],
      [-1, 0],
      [1, 0],
      [-1, 1],
      [0, 1],
      [1, 1],
    ].map(([dx, dy]) => new Vec2d(this.x + dx, this.y + dy));
  }

  static fromHash(hash: string): Vec2d {
    const [x, y] = hash.split(",").map((it) => parseInt(it, 10));
    return new Vec2d(x, y);
  }
}

const DIR = {
  RIGHT: new Vec2d(1, 0),
  UP: new Vec2d(0, -1),
  LEFT: new Vec2d(-1, 0),
  DOWN: new Vec2d(0, 1),
} as const;

const directions = ["RIGHT", "UP", "LEFT", "DOWN"] as const;
