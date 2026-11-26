// Camel Cards, part 2: J is a joker: weakest card, but it joins the largest group for the type.
// TypeScript: same comparator, different rules object.
import { winnings } from "./cards";

export const solve = (input: string) => winnings(input, { order: "J23456789TQKA", jokers: true });
