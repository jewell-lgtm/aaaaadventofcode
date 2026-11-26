// Monkey in the Middle, part 2: 10000 rounds, no relief; keep worry modulo the divisor product.
// TypeScript: the modulus keeps values far below 2^53, so plain numbers stay exact.
import { monkeyBusiness } from "./monkeys";

export const solve = (input: string) => monkeyBusiness(input, 10_000, false);
