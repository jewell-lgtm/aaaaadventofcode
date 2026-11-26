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

export function serializeExamples(examples: Example[]): string {
  const head = "# Examples for `aoc test`. Edit freely: fix expected values, add args, add more [[example]] blocks.\n";
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
