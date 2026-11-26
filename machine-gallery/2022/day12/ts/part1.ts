// Hill Climbing Algorithm, part 1: BFS layer by layer from S to E.
// TypeScript: arrays of frontier points; a Set of "r,c" strings for visited.
import { shortestPath } from "./hill";

export const solve = (input: string) => shortestPath(input, ["S"]);
