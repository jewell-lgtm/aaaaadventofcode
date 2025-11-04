import { solve as knotHash } from "../day10/part2";

export function solve(input: string): number | string {
  const values = Array.from({ length: 128 }, (_, i) => `${input.trim()}-${i}`);
  const hashed = values.map((it) => knotHash(it));

  let squares = 0;

  for (const hash of hashed) {
    for (const char of hexToBinary(hash)) {
      if (char === "1") squares++;
    }
  }

  return squares;
}

function hexToBinary(hex: string): string {
  let binary = "";

  for (let i = 0; i < hex.length; i++) {
    const hexDigit = hex[i];
    const decimal = parseInt(hexDigit, 16);
    const binaryDigit = decimal.toString(2).padStart(4, "0");
    binary += binaryDigit;
  }

  return binary;
}
