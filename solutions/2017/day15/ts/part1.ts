export function solve(input: string): number | string {
  const [first, second] = input.trim().split("\n");
  const aStart = parseInt(first.split(" ")[4], 10);
  const bStart = parseInt(second.split(" ")[4], 10);

  const genA = generator(16807, aStart);
  const genB = generator(48271, bStart);

  let matches = 0;

  for (let i = 0; i < 40000000; i++) {
    if (genA.next() === genB.next()) {
      matches++;
    }
  }

  // Your solution here

  return matches;
}

function generator(factor: number, start: number) {
  const mod = 2147483647;
  let prev = start;
  return {
    next() {
      prev = (prev * factor) % mod;
      // just return the lowest 16 bits
      return prev & 0xffff;
    },
  };
}
