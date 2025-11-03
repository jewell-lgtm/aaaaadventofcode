export function solve(input: string): number | string {
  const lines = input.trim().split(/\s+/);

  const banks = lines.map((line) => parseInt(line, 10));

  const seenConfigurations = new Set<string>();
  seenConfigurations.add(banks.join(","));

  let steps = 0;
  let loop = true;
  while (true) {
    steps++;
    redistribute(banks);
    if (seenConfigurations.has(banks.join(","))) {
      loop = false;
      break;
    }
    seenConfigurations.add(banks.join(","));
  }

  let currentConfiguration = banks.join(",");
  redistribute(banks);
  let loopSize = 1;
  while (banks.join(",") !== currentConfiguration) {
    redistribute(banks);
    loopSize++;
  }

  return loopSize;
}

function redistribute(banks: number[]) {
  let redistIndex = 0;
  let max = 0;
  for (let i = 0; i < banks.length; i++) {
    if (banks[i] > max) {
      redistIndex = i;
      max = banks[i];
    }
  }

  let toRedistribute = banks[redistIndex];
  banks[redistIndex] = 0;
  redistIndex = (redistIndex + 1) % banks.length;

  while (toRedistribute > 0) {
    toRedistribute--;
    banks[redistIndex]++;
    redistIndex = (redistIndex + 1) % banks.length;
  }
}
