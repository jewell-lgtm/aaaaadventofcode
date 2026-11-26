export function solve(input: string): number | string {
  const lines = input.trim().split("\n");

  let result = 0;

  for (const passphrase of lines) {
    const seen = new Set<string>();
    const words = passphrase.trim().split(/\s+/);
    let valid = 1;
    for (const word of words) {
      if (seen.has(word)) {
        valid = 0;
        break;
      }
      seen.add(word);
    }
    result += valid;
  }

  return result;
}
