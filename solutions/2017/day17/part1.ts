export function solve(input: string): number | string {
  const stepSize = parseInt(input.trim(), 10);

  // hmmm... will I get punished for the naive solution here

  const buffer = [0];
  let pos = 0;

  for (let i = 1; i <= 2017; i++) {
    pos = (pos + stepSize) % buffer.length;
    const before = buffer.slice(0, pos + 1);
    const after = buffer.slice(pos + 1);

    for (let j = 0; j < before.length; j++) {
      buffer[j] = before[j];
    }
    buffer[before.length] = i;
    for (let j = 0; j < after.length; j++) {
      buffer[before.length + 1 + j] = after[j];
    }

    pos = before.length;
  }

  const index = (buffer.indexOf(2017) + 1) % buffer.length;
  return buffer[index];
}
