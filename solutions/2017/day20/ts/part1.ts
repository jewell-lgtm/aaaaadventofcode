import assert from "assert";

export function solve(input: string): number | string {
  const particles = input
    .trim()
    .split("\n")
    .map((it, i) => parseLine(it, i));

  let max = -Infinity;

  for (const particle of particles) {
    max = Math.max(
      max,
      turnsTilDiverging(particle.px, particle.vx, particle.ax),
    );
    max = Math.max(
      max,
      turnsTilDiverging(particle.py, particle.vy, particle.ay),
    );
    max = Math.max(
      max,
      turnsTilDiverging(particle.pz, particle.vz, particle.az),
    );
  }

  // simulate for X steps, until all particles are diverging
  for (let i = 0; i < max; i++) {
    particles.forEach((p) => p.tick());
  }

  const divergingAt = new Map(
    particles.map((particle) => {
      const d1 = distance({ px: 0, py: 0, pz: 0 }, particle);
      particle.tick();
      const d2 = distance({ px: 0, py: 0, pz: 0 }, particle);
      return [particle.id, d2 - d1];
    }),
  );

  assert(smallest(divergingAt.values()) > 0);

  const divergingSlowest = [...divergingAt.entries()].find(([_, at]) => {
    return at === smallest(divergingAt.values());
  });

  return divergingSlowest![0];
}

type Particle = ReturnType<typeof parseLine>;
type Position = { px: number; py: number; pz: number };
const regex =
  /p=<(-?\d+),(-?\d+),(-?\d+)>, v=<(-?\d+),(-?\d+),(-?\d+)>, a=<(-?\d+),(-?\d+),(-?\d+)>/;
function parseLine(str: string, id: number) {
  if (!regex.test(str)) {
    throw new Error(`Invalid line: ${str}`);
  }

  const [px, py, pz, vx, vy, vz, ax, ay, az] = regex
    .exec(str)!
    .slice(1)
    .map(Number);

  return {
    id,
    px,
    py,
    pz,
    vx,
    vy,
    vz,
    ax,
    ay,
    az,
    tick() {
      this.vx += this.ax;
      this.vy += this.ay;
      this.vz += this.az;
      this.px += this.vx;
      this.py += this.vy;
      this.pz += this.vz;
    },
    toString() {
      return `particle: ${id}, p=<${this.px},${this.py},${this.pz}>, v=<${this.vx},${this.vy},${this.vz}>, a=<${this.ax},${this.ay},${this.az}>`;
    },
  };
}

function distance(a: Position, b: Position) {
  const x = Math.abs(a.px - b.px);
  const y = Math.abs(a.py - b.py);
  const z = Math.abs(a.pz - b.pz);
  return x + y + z;
}

function turnsTilDiverging(p: number, v: number, a: number): number {
  let p1 = p,
    v1 = v,
    a1 = a,
    steps = 0;
  while (true) {
    steps++;
    if (p1 > 0 && v1 >= 0 && a1 >= 0) return steps;
    if (p1 < 0 && v1 <= 0 && a1 <= 0) return steps;
    p1 += v1;
    v1 += a1;
  }
  throw new Error("Unreachable");
}

function smallest(ns: Iterable<number>): number {
  let result = Infinity;
  for (const n of ns) {
    result = Math.min(result, n);
  }
  return result;
}

function biggest(ns: Iterable<number>): number {
  let result = -Infinity;
  for (const n of ns) {
    result = Math.max(result, n);
  }
  return result;
}
