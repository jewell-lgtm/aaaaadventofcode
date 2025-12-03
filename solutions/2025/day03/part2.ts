export function solve(input: string): number | string {
  const lines = input.trim().split("\n");

  const digitLength = 12;
  let result = BigInt(0);
  for (const line of lines) {
    const positions = Array.from(
      { length: digitLength },
      (_, i) => line.length - digitLength + i,
    );
    function collect(at: number[]) {
      const digits = at.map((it) => line[it]);
      return BigInt(digits.join(""));
    }
    let biggest = collect(positions);
    for (let posI = 0; posI < positions.length; posI++) {
      const min = posI === 0 ? 0 : positions[posI - 1] + 1;
      const max =
        posI === positions.length - 1
          ? line.length - 1
          : positions[posI + 1] - 1;
      // move the digit to the left, and slide to the right to see if we can improve it
      positions[posI] = min;
      biggest = collect(positions);
      for (let j = min; j <= max; j++) {
        const guess = positions.map((p, idx) => (idx === posI ? j : p));
        if (collect(guess) > biggest) {
          biggest = collect(guess);
          positions[posI] = j;
        }
      }
    }
    result += biggest;
  }

  return result.toString();
}
