// Chiton, part 2: the map tiles 5x5 with risk incremented per tile (wrapping 9 -> 1).
// TypeScript: risk() computes tiled cells on the fly; nothing is materialised.
import { lowestRisk } from "./chiton";

export const solve = (input: string) => lowestRisk(input, 5);
