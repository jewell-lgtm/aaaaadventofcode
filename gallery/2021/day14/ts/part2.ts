// Extended Polymerization, part 2: 40 steps; the string would be ~20 trillion long, pair counts stay tiny.
// TypeScript: same counter; the answer (~1e13) is still exact as a number.
import { polymerSpread } from "./polymer";

export const solve = (input: string) => polymerSpread(input, 40);
