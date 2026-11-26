// Hot Springs, part 1: sum the number of valid arrangements per row.
// TypeScript: a closure-captured Map memoises the recursive count.
import { totalArrangements } from "./springs";

export const solve = (input: string) => totalArrangements(input, 1);
