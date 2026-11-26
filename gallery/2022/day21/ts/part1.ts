// Monkey Math, part 1: recursively evaluate the expression tree from root.
// TypeScript: a discriminated union (kind: "num" | "op") narrows each node.
import { evaluate, parse } from "./monkeys";

export const solve = (input: string) => evaluate(parse(input), "root");
