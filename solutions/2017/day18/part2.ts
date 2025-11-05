import assert from "assert";
export function solve(input: string): number | string {
  const lines = input.trim().split("\n");

  const a = createProgram(lines, 0);
  const b = createProgram(lines, 1);

  while (true) {
    a.executeUntilReceive();
    b.executeUntilReceive();
    const aReceivedMessages = a.receiveMessages(b);
    const bReceivedMessages = b.receiveMessages(a);
    if (!aReceivedMessages && !bReceivedMessages) {
      return b.sentMessageCount();
    }
  }

  throw new Error("Program didnt terminate");
}

function createProgram(lines: string[], id: 0 | 1) {
  const registers = new Map<string, number>([["p", id]]);
  const outbox: number[] = [];
  const inbox: number[] = [];
  let sentMessageCount = 0;

  let i = 0;

  function valueOf(str: string) {
    if (/-?\d+/.test(str)) {
      return parseInt(str, 10);
    }
    return registers.get(str) ?? 0;
  }

  function get(register: string): number {
    if (!registers.has(register)) {
      registers.set(register, 0);
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
      sentMessageCount++;
      const val = valueOf(args[0]);
      outbox.push(val);
      i++;
    },
    rcv(args: string[]) {
      const register = args[0];
      assert(inbox.length > 0, "trying to receive with an empty inbox");
      registers.set(register, inbox.shift()!);
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

  return {
    sentMessageCount() {
      return sentMessageCount;
    },
    executeUntilReceive() {
      while (lines[i].includes("rcv") === false) {
        const line = lines[i];
        const [first, ...rest] = line.split(" ");
        const instruction = instructions[first as keyof typeof instructions];
        assert(instruction, "no instruction for " + line);
        instruction(rest);
      }
    },
    receiveMessages(other: { sendMessages: () => number[] }): boolean {
      const [first, ...rest] = lines[i].split(" ");
      assert(
        first.includes("rcv"),
        "should only receive on a rcv instruction, got " + first,
      );

      const messages = other.sendMessages();
      for (const message of messages) {
        inbox.push(message);
      }
      if (inbox.length === 0) return false;

      instructions.rcv(rest);
      return true;
    },
    sendMessages() {
      const result = [...outbox];
      outbox.length = 0;
      return result;
    },
  };
}
