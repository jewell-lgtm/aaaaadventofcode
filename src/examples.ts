import { existsSync, mkdirSync, readFileSync, writeFileSync } from "fs";
import { join } from "path";
import { dayDir, type Part } from "./store";

/**
 * examples.toml, hand-editable:
 *   [[example]]
 *   input = "examples/1.txt"     # or: text = """..."""
 *   part1 = "142"                # expected; omit/"" = no check for that part
 *   part2 = ""
 *   args = { steps = 6 }         # → AOC_ARGS for example-specific constants
 *   auto = true                  # extracted by aoc; false once you've checked it
 */
export interface Example {
  input?: string;
  text?: string;
  part1?: string;
  part2?: string;
  args?: Record<string, unknown>;
  auto?: boolean;
}

const file = (y: number, d: number) => join(dayDir(y, d), "examples.toml");

export function loadExamples(year: number, day: number): Example[] {
  const f = file(year, day);
  if (!existsSync(f)) return [];
  const parsed = Bun.TOML.parse(readFileSync(f, "utf8")) as { example?: Example[] };
  return (parsed.example ?? []).map((e) => ({
    ...e,
    part1: e.part1 === undefined ? undefined : String(e.part1),
    part2: e.part2 === undefined ? undefined : String(e.part2),
  }));
}

export function exampleInput(year: number, day: number, ex: Example): string {
  if (ex.text !== undefined) return ex.text;
  if (!ex.input) throw new Error("example has neither input nor text");
  return readFileSync(join(dayDir(year, day), ex.input), "utf8");
}

export const expected = (ex: Example, part: Part): string | undefined => (part === 1 ? ex.part1 : ex.part2) || undefined;

const str = (s: string) => JSON.stringify(s);

function inlineTable(o: Record<string, unknown>): string {
  return `{ ${Object.entries(o).map(([k, v]) => `${/^[A-Za-z0-9_-]+$/.test(k) ? k : str(k)} = ${typeof v === "string" ? str(v) : JSON.stringify(v)}`).join(", ")} }`;
}

/** Top of every examples.toml: what an entry looks like, since you'll be adding/fixing them by hand. */
export const EXAMPLES_HEADER = `# Tests for \`:Aoc test\`. Filled from the puzzle text; edit freely, aoc never overwrites your values.
#
# One [[example]] block per test. Every field:
#
# [[example]]
# input = "examples/3.txt"          # input from a file (path relative to this day dir)
# text = """1,2,3"""                # …or inline instead of \`input\` (good for one-liners)
# part1 = "6"                       # expected answer for part 1 ("" = don't check part 1)
# part2 = "36"                      # expected answer for part 2 ("" = don't check part 2)
# args = { size = 7, steps = 12 }   # constants that differ in the example: read with arg("size", 71)
# auto = false                      # true = extracted by aoc; set false once you've checked it
#
# Add one from the clipboard instead:  pbpaste | aoc ex add p2 36

`;

export function serializeExamples(examples: Example[]): string {
  const head = EXAMPLES_HEADER;
  return (
    head +
    examples
      .map((e) => {
        const lines = ["[[example]]"];
        if (e.input) lines.push(`input = ${str(e.input)}`);
        if (e.text !== undefined) lines.push(`text = """${e.text.replace(/\\/g, "\\\\").replace(/"""/g, '\\"\\"\\"')}"""`);
        lines.push(`part1 = ${str(e.part1 ?? "")}`, `part2 = ${str(e.part2 ?? "")}`);
        if (e.args && Object.keys(e.args).length) lines.push(`args = ${inlineTable(e.args)}`);
        if (e.auto !== undefined) lines.push(`auto = ${e.auto}`);
        return lines.join("\n");
      })
      .join("\n\n") +
    "\n"
  );
}

export function saveExamples(year: number, day: number, examples: Example[]): void {
  mkdirSync(dayDir(year, day), { recursive: true });
  writeFileSync(file(year, day), serializeExamples(examples));
}

/** Writes examples/<n>.txt and returns the relative path. */
export function writeExampleFile(year: number, day: number, n: number, text: string): string {
  const rel = `examples/${n}.txt`;
  mkdirSync(join(dayDir(year, day), "examples"), { recursive: true });
  writeFileSync(join(dayDir(year, day), rel), text);
  return rel;
}
