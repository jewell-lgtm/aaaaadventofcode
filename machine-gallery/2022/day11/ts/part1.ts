// Monkey in the Middle, part 1: 20 rounds, worry divided by 3 after each inspection.
// TypeScript: each monkey's operation is parsed once into a closure.
import { monkeyBusiness } from "./monkeys";

export const solve = (input: string) => monkeyBusiness(input, 20, true);
