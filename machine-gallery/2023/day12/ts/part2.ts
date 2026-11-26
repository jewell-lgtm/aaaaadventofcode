// Hot Springs, part 2: unfold each row 5x (joined by '?') and its groups 5x.
// TypeScript: counts stay below 2^53 for real inputs, so number is enough.
import { totalArrangements } from "./springs";

export const solve = (input: string) => totalArrangements(input, 5);
