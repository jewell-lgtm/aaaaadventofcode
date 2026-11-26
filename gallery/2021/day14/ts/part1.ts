// Extended Polymerization, part 1: 10 insertion steps, then most common minus least common element.
// TypeScript: Map<string, number> as a counter; counts fit comfortably in a double.
import { polymerSpread } from "./polymer";

export const solve = (input: string) => polymerSpread(input, 10);
