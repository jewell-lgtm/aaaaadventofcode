export function solve(input: string): number | string {
  const chars = input.trim().split("");

  const parser = createParser();

  for (const char of chars) {
    parser.parse(char);
  }

  // Your solution here

  return parser.score();
}

function createParser() {
  let garbage = false;
  let score = 0;
  let depth = 0;
  let ignoreNext = false;

  return {
    parse: (char: string) => {
      if (ignoreNext) {
        ignoreNext = false;
        return;
      }
      if (char === "!") {
        ignoreNext = true;
        return;
      }
      if (garbage) {
        if (char === ">") {
          garbage = false;
        }
        return;
      }
      if (char === "<") {
        garbage = true;
        return;
      }
      if (char === ",") return;
      if (char === "{") {
        depth++;
        return;
      }
      if (char === "}") {
        score += depth;
        depth--;
        return;
      }
      throw new Error(`Char ${char} is unrecognized`);
    },
    score() {
      return score;
    },
  };
}
