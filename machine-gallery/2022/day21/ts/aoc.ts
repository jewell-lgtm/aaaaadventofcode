const ARGS: Record<string, unknown> = JSON.parse(process.env.AOC_ARGS || "{}");

/** True when running an example (aoc test). */
export const example = process.env.AOC_EXAMPLE === "1";

/** Example-specific constant from examples.toml `args`, else the real-input default. */
export function arg<T>(name: string, fallback: T): T {
  return name in ARGS ? (ARGS[name] as T) : fallback;
}
