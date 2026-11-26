import assert from "assert";

export function solve(input: string): number | string {
  const particles = input
    .trim()
    .split("\n")
    .map((it, i) => parseLine(it, i));

  const remaining = new Set(particles);

  // simulate until all particles are moving away from each other
  while (true) {
    // update all particles
    for (const p of remaining) {
      p.tick();
    }

    // detect collisions - group particles by position
    const positionMap = new Map<string, Particle[]>();
    for (const particle of remaining) {
      const key = `${particle.px},${particle.py},${particle.pz}`;
      if (!positionMap.has(key)) {
        positionMap.set(key, []);
      }
      positionMap.get(key)!.push(particle);
    }

    // remove all particles that collided (2 or more at same position)
    for (const [_, particlesAtPos] of positionMap) {
      if (particlesAtPos.length > 1) {
        particlesAtPos.forEach((p) => remaining.delete(p));
      }
    }

    // check if all remaining particles are moving away from each other
    const particleArray = [...remaining];
    let allDiverging = true;

    for (let i = 0; i < particleArray.length && allDiverging; i++) {
      for (let j = i + 1; j < particleArray.length && allDiverging; j++) {
        const p1 = particleArray[i];
        const p2 = particleArray[j];

        const dist1 = distance(p1, p2);

        // simulate one step ahead to check if distance is increasing
        const p1Next = {
          px: p1.px + p1.vx + p1.ax,
          py: p1.py + p1.vy + p1.ay,
          pz: p1.pz + p1.vz + p1.az,
        };
        const p2Next = {
          px: p2.px + p2.vx + p2.ax,
          py: p2.py + p2.vy + p2.ay,
          pz: p2.pz + p2.vz + p2.az,
        };

        const dist2 = distance(p1Next, p2Next);

        if (dist2 <= dist1) {
          allDiverging = false;
        }
      }
    }

    if (allDiverging) {
      break;
    }
  }

  return remaining.size;
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
