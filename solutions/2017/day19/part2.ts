import assert from "assert";

export function solve(input: string): number | string {
  const grid = input.split("\n");
  let dir = [1, 0] as [number, number];
  let pos = [0, grid[0].indexOf("|")] as [number, number];
  let steps = 1;
  assert(pos[1] > -1);

  function canGo(dir: [number, number]): boolean {
    if (!inBounds(plus(pos, dir))) return false;
    const nextPos = at(plus(pos, dir));

    return nextPos !== " ";
  }

  function go(dir: [number, number]) {
    pos = plus(dir, pos);
    steps++;
  }

  function at(pos: [number, number]) {
    return grid[pos[0]][pos[1]];
  }

  function inBounds(pos: [number, number]) {
    return (
      pos[0] > 0 &&
      pos[0] < grid.length &&
      pos[1] > 0 &&
      pos[1] < grid[pos[0]].length
    );
  }

  function turn(): boolean {
    const optionOne: [number, number] = [dir[1], dir[0]];
    const optionTwo: [number, number] = [0 - dir[1], 0 - dir[0]];
    if (canGo(optionOne)) dir = optionOne;
    else if (canGo(optionTwo)) dir = optionTwo;
    else {
      return false;
    }
    return true;
  }

  let canContinue = true;
  while (canContinue) {
    while (canGo(dir)) {
      go(dir);
    }
    canContinue = turn();
  }

  return steps;
}

function plus(a: [number, number], b: [number, number]): [number, number] {
  return [a[0] + b[0], a[1] + b[1]];
}
