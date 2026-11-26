export function solve(input: string): number | string {
  const lengths = input
    .trim()
    .split(",")
    .map((it) => parseInt(it.trim(), 10));

  let pos = 0;
  let skip = 0;

  const string = Array.from({ length: 256 }, (_, i) => i);

  for (const length of lengths) {
    // don't be tempted to try and save a few bytes of memory here
    const reversed = new Array(length);
    for (let i = 0; i < length; i++) {
      const index = (pos + i) % string.length;
      reversed[reversed.length - 1 - i] = string[index];
    }
    for (let i = 0; i < length; i++) {
      string[(pos + i) % string.length] = reversed[i];
    }
    pos = (pos + length + skip) % string.length;
    skip++;
  }

  return string[0] * string[1];
}
