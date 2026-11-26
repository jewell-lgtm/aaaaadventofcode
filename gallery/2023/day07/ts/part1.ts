// Camel Cards, part 1: rank hands by type, then by card strength left to right.
// TypeScript: a custom comparator to Array.sort chaining two keys with ||.
import { winnings } from "./cards";

export const solve = (input: string) => winnings(input, { order: "23456789TJQKA", jokers: false });
