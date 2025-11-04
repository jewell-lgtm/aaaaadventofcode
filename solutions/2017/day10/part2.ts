export function solve(input: string): number | string {
  const inputBytes = input
    .trim()
    .split("")
    .flatMap((it) => it.charCodeAt(0));

  [17, 31, 73, 47, 23].forEach((it) => inputBytes.push(it));

  let pos = 0;
  let skip = 0;

  const string = Array.from({ length: 256 }, (_, i) => i);

  for (let round = 0; round < 64; round++) {
    for (const length of inputBytes) {
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
  }

  let result = "";
  for (let block = 0; block < 16; block++) {
    let blockResult = 0;
    for (let i = 0; i < 16; i++) {
      blockResult ^= string[block * 16 + i];
    }
    result += blockResult.toString(16).padStart(2, "0");
  }

  return result;
}
