// Shared: parse each monkey block into a record with an operation closure, then simulate.
type Monkey = {
  items: number[];
  op: (old: number) => number;
  divisor: number;
  target: { true: number; false: number };
  inspected: number;
};

function parseMonkey(block: string): Monkey {
  const nums = (line: string) => (line.match(/\d+/g) ?? []).map(Number);
  const [, items, operation, test, ifTrue, ifFalse] = block.split("\n");
  const [, operator, operand] = operation.match(/old ([*+]) (\w+)/)!;
  const value = (old: number) => (operand === "old" ? old : +operand);
  return {
    items: nums(items),
    op: operator === "*" ? (old) => old * value(old) : (old) => old + value(old),
    divisor: nums(test)[0],
    target: { true: nums(ifTrue)[0], false: nums(ifFalse)[0] },
    inspected: 0,
  };
}

export function monkeyBusiness(input: string, rounds: number, relief: boolean): number {
  const monkeys = input.trimEnd().split("\n\n").map(parseMonkey);
  // All tests are divisibility checks, so worry levels can live modulo the product of divisors.
  const modulus = monkeys.reduce((m, k) => m * k.divisor, 1);
  for (let round = 0; round < rounds; round++) {
    for (const monkey of monkeys) {
      for (const item of monkey.items.splice(0)) {
        const worry = relief ? Math.floor(monkey.op(item) / 3) : monkey.op(item) % modulus;
        monkeys[monkey.target[`${worry % monkey.divisor === 0}`]].items.push(worry);
        monkey.inspected++;
      }
    }
  }
  const [a, b] = monkeys.map((m) => m.inspected).sort((x, y) => y - x);
  return a * b;
}
