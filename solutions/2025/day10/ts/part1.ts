type Machine = {
  target: boolean[];
  buttons: Set<number>[];
  joltage: number[];
};

export function solve(input: string): number | string {
  const machines = input
    .trim()
    .split("\n")
    .map((it) => parseMachine(it));

  return sum(machines.map((it) => buttonPresses(it)));
}

function sum(arr: number[]): number {
  return arr.reduce((a, b) => a + b, 0);
}

function buttonPresses(machine: Machine): number {
  const length = machine.target.length;
  const seen = new Set<string>();
  const pQueue = PQueue.create<{ state: boolean[]; machine: Machine }>();
  pQueue.insert(0, { state: Array.from({ length }, () => false), machine });
  while (pQueue.items.length > 0) {
    const [pushed, next] = pQueue.items.shift()!!;

    for (const button of machine.buttons) {
      const nextState = calcState(next.state, button);
      if (isTarget(nextState, machine.target)) {
        return pushed + 1;
      }
      if (seen.has(nextState.join(","))) continue;
      seen.add(nextState.join(","));

      pQueue.insert(pushed + 1, { state: nextState, machine });
    }
  }

  return -1;
}

// fuck regex
function parseMachine(line: string): Machine {
  const result: Machine = { target: [], buttons: [], joltage: [] };

  for (let i = 0; i < line.length; i++) {
    if (line[i] === "[") {
      i++;
      while (line[i] !== "]" && i < line.length) {
        result.target.push(line[i] === "#");
        i++;
      }
      i++;
    }
    if (line[i] === "(") {
      let j = i + 1;
      while (line[j] !== ")") {
        j++;
      }
      const group = line
        .slice(i + 1, j)
        .split(",")
        .map(Number);
      result.buttons.push(new Set(group));
      i = j;
    }
    if (line[i] === "{") {
      let j = i + 1;
      while (line[j] !== "}") {
        j++;
      }
      const joltage = line
        .slice(i + 1, j)
        .split(",")
        .map(Number);
      result.joltage.push(...joltage);
      i = j;
    }
  }

  return result;
}

class PQueue<T> {
  items: [number, T][] = [];

  static create<T>(): PQueue<T> {
    return new PQueue<T>();
  }

  insert(priority: number, item: T) {
    this.items.push([priority, item]);
    this.items.sort((a, b) => a[0] - b[0]);
  }
}

function isTarget(state: boolean[], target: boolean[]): boolean {
  for (let i = 0; i < state.length; i++) {
    if (state[i] !== target[i]) return false;
  }
  return true;
}

function calcState(state: boolean[], button: Set<number>): boolean[] {
  return state.map((it, i) => (button.has(i) ? !it : it));
}
