export function solve(input: string): number | string {
  const lines = input.trim().split("\n");
  const instructions = lines.map(parseInstruction);
  const registers = createRegisters();

  for (const instruction of instructions) {
    const valA = registers.get(instruction.compRegister);
    const valB = instruction.compLiteral;
    if (instruction.condition(valA, valB)) {
      registers.set(instruction.register, instruction.diff);
    }
  }

  return registers.largestEver();
}

function createRegisters() {
  const registers = new Map<string, number>();

  return {
    set: (name: string, diff: number) => {
      if (!registers.has(name)) {
        registers.set(name, 0);
      }
      registers.set(name, registers.get(name)! + diff);
    },
    get: (name: string): number => {
      if (!registers.has(name)) {
        registers.set(name, 0);
      }
      return registers.get(name)!;
    },
    largest: (): number => {
      let result = -Infinity;
      for (const value of registers.values()) {
        if (value > result) result = value;
      }
      return result;
    },
  };
}

type Instruction = {
  register: string;
  diff: number;
  condition: (a: number, b: number) => boolean;
  compRegister: string;
  compLiteral: number;
};

const regex = /(\w+) (inc|dec) (-?\d+) if (\w+) ([!<>=]+) (-?\d+)/;
function parseInstruction(line: string): Instruction {
  // b inc 5 if a > 1
  const groups = line.match(regex);
  if (!groups) throw new Error(`Invalid instruction: ${line}`);
  return {
    register: groups[1],
    diff:
      groups[2] === "inc"
        ? parseInt(groups[3], 10)
        : 0 - parseInt(groups[3], 10),
    condition: parseCondition(groups[5]),
    compRegister: groups[4],
    compLiteral: parseInt(groups[6]),
  };
}

function parseCondition(input: string): (a: number, b: number) => boolean {
  return (a, b) => eval(`${a} ${input} ${b}`);
}
