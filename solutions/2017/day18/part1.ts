import assert from "assert";
export function solve(input: string): number | string {
  const lines = input.trim().split("\n");
  const registers = new Map<string, number>();

  let i = 0;
  let result: number | null = null;

  function valueOf(str: string) {
    if (/-?\d+/.test(str)) {
      return parseInt(str, 10);
    }
    return registers.get(str) ?? 0;
  }

  function get(register: string): number {
    if (!registers.has(register)) {
      registers.set(register, 0);
      return 0;
    }
    return registers.get(register)!;
  }

  const instructions = {
    set(args: string[]) {
      const [register, valStr] = args;
      registers.set(register, valueOf(valStr));
      i++;
    },
    add(args: string[]) {
      const [register, valStr] = args;
      registers.set(register, get(register) + valueOf(valStr));
      i++;
    },
    mul(args: string[]) {
      const [register, valStr] = args;
      registers.set(register, get(register) * valueOf(valStr));
      i++;
    },
    mod(args: string[]) {
      const [register, valStr] = args;
      registers.set(register, get(register) % valueOf(valStr));
      i++;
    },
    snd(args: string[]) {
      registers.set("sound", valueOf(args[0]));
      i++;
    },
    rcv(args: string[]) {
      if (valueOf(args[0]) !== 0) {
        result = get("sound");
      }
      i++;
    },
    jgz(args: string[]) {
      const [x, y] = args;
      if (valueOf(x) > 0) {
        i = (i + valueOf(y)) % lines.length;
      } else {
        i++;
      }
    },
  } as const;

  while (result == null) {
    const line = lines[i];
    const [first, ...rest] = line.split(" ");
    const instruction = instructions[first as keyof typeof instructions];
    assert(instruction, "no instruction for " + line);
    instruction(rest);
  }

  return result;
}
