// Chiton, part 1: lowest total risk from top-left to bottom-right.
// TypeScript: flat typed indices (r * W + c) and a sparse array of buckets.
import { lowestRisk } from "./chiton";

export const solve = (input: string) => lowestRisk(input, 1);
