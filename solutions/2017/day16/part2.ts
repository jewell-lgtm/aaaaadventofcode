export function solve(input: string): number | string {
  const instructions = input.trim().split(",");

  const tape = "abcdefghijklmnop".split("");

  const seenConfigurations = new Set<string>();

  while (!seenConfigurations.has(tape.join(""))) {
    seenConfigurations.add(tape.join(""));
    for (const instruction of instructions) {
      if (instruction[0] === "s") {
        const amount = parseInt(instruction.slice(1), 10);
        const last = tape.slice(0 - amount);
        const first = tape.slice(0, 0 - amount);

        for (let i = 0; i < last.length; i++) {
          tape[i] = last[i];
        }
        for (let i = 0; i < first.length; i++) {
          tape[i + last.length] = first[i];
        }

        continue;
      }

      if (instruction[0] === "x") {
        const [first, second] = instruction
          .slice(1)
          .split("/")
          .map((it) => parseInt(it, 10));

        const temp = tape[first];
        tape[first] = tape[second];
        tape[second] = temp;

        continue;
      }

      if (instruction[0] === "p") {
        const [first, second] = instruction
          .slice(1)
          .split("/")
          .map((it) => tape.indexOf(it));

        const temp = tape[first];
        tape[first] = tape[second];
        tape[second] = temp;

        continue;
      }

      throw new Error("TODO: " + instruction);
    }
  }

  console.log(`tape repeats every ${seenConfigurations.size}`);
  console.log(
    `running the loop 1000000000 times is the same as running it ${1000000000 % seenConfigurations.size} times`,
  );

  return [...seenConfigurations.values()][1000000000 % seenConfigurations.size];
}
