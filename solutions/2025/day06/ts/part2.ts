export function solve(input: string): number | string {
  const grid = removeBlankLines(input)
    .split("\n")
    .map((it) => it.split("").reverse());
  console.log(grid);

  let result = 0n;
  const sum: bigint[] = [];
  for (let i = 0; i < grid[0].length; i++) {
    const nums: string[] = [];
    for (let j = 0; j < grid.length; j++) {
      if (j === grid.length - 1) {
        const num = nums.join("");
        if (Number(num) > 0) {
          sum.push(BigInt(nums.join("")));
        }
        if (grid[j][i] === "+") {
          result += sum.reduce((a, b) => a + b, 0n);
          sum.length = 0;
        } else if (grid[j][i] === "*") {
          result += sum.reduce((a, b) => a * b, 1n);
          sum.length = 0;
        }
      }
      nums.push(grid[j][i]);
    }
  }

  // Your solution here

  return result.toString();
}

function removeBlankLines(input: string): string {
  return input
    .split("\n")
    .filter((line) => line.trim() !== "")
    .join("\n");
}
