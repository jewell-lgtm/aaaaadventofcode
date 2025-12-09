export function solve(input: string): number | string {
  const points = input
    .trim()
    .split("\n")
    .map((it) => parseLine(it));

  const queue: QueueItem[] = [];

  for (let i = 0; i < points.length; i++) {
    for (let j = i + 1; j < points.length; j++) {
      const dist = straightLineDistance(points[i], points[j]);
      queue.push({ dist, coords: definitiveOrder(points[i], points[j]) });
    }
  }

  queue.sort((a, b) => a.dist - b.dist);

  const connections: Set<Coord>[] = [];

  let r = 1_000;

  for (let i = 0; i < r; i++) {
    const a = queue[i].coords[0];
    const b = queue[i].coords[1];
    let connected = false;
    for (const set of connections) {
      if (set.has(a) || set.has(b)) {
        set.add(a);
        set.add(b);
        connected = true;
      }
    }
    if (!connected) {
      connections.push(new Set<Coord>([a, b]));
    }
    consolidateConnections();
  }

  const setSizes = connections.map((it) => it.size).toSorted((a, b) => b - a);

  console.log(setSizes);

  return product(setSizes.slice(0, 3));

  function consolidateConnections() {
    for (let i = 0; i < connections.length; i++) {
      for (let j = i + 1; j < connections.length; j++) {
        if (hasIntersection(connections[i], connections[j])) {
          addAll(connections[i], connections[j]);
          connections.splice(j, 1);
        }
      }
    }
  }
}

type Coord = [number, number, number];

function straightLineDistance(a: Coord, b: Coord): number {
  return Math.sqrt(
    (a[0] - b[0]) ** 2 + (a[1] - b[1]) ** 2 + (a[2] - b[2]) ** 2,
  );
}

function definitiveOrder(a: Coord, b: Coord): [Coord, Coord] {
  return [a, b].sort((aa, bb) => {
    return aa[0] - bb[0] || aa[1] - bb[1] || aa[2] - bb[2];
  }) as [Coord, Coord];
}

function parseLine(line: string): Coord {
  const s = line.split(",").map(Number);
  if (s.length !== 3) {
    throw new Error(`Invalid line: ${line}`);
  }
  return s as Coord;
}

function key(a: Coord, b: Coord): string {
  return `${a.join(",")}|${b.join(",")}`;
}

function fromKey(k: string): [Coord, Coord] {
  return k.split("|").map((it) => it.split(",").map(Number) as Coord) as [
    Coord,
    Coord,
  ];
}

type QueueItem = {
  dist: number;
  coords: [Coord, Coord];
};

function hasIntersection(setA: Set<Coord>, setB: Set<Coord>): boolean {
  return Array.from(setA).some((item) => setB.has(item));
}

function addAll(setA: Set<Coord>, setB: Set<Coord>) {
  for (const item of setB) {
    setA.add(item);
  }
}

function product(xs: number[]): number {
  return xs.reduce((a, b) => a * b, 1);
}
