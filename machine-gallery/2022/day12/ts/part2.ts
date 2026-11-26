// Hill Climbing Algorithm, part 2: start from every lowest square at once (multi-source BFS).
// TypeScript: same BFS, seeded with all 'a' and 'S' cells.
import { shortestPath } from "./hill";

export const solve = (input: string) => shortestPath(input, ["S", "a"]);
