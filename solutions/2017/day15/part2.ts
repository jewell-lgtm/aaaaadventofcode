export function solve(input: string): number | string {
  const [first, second] = input.trim().split("\n");
  const aStart = parseInt(first.split(" ")[4], 10);
  const bStart = parseInt(second.split(" ")[4], 10);

  const genA = generator(16807, aStart, 4);
  const genB = generator(48271, bStart, 8);

  let matches = 0;

  for (let i = 0; i < 5000000; i++) {
    if (genA.next() === genB.next()) {
      matches++;
    }
  }

  // Your solution here

  return matches;
}

function generator(factor: number, start: number, multiple: number) {
  const mod = 2147483647;
  let prev = start;
  return {
    next() {
      prev = (prev * factor) % mod;
      while (prev % multiple !== 0) {
        prev = (prev * factor) % mod;
      }
      // just return the lowest 16 bits
      return prev & 0xffff;
    },
  };
}
