import { existsSync, readFileSync } from "fs";
import { join } from "path";
import { exampleInput, expected, loadExamples } from "../examples";
import type { RunResult } from "../runner";
import { prepared, type Session } from "../session";
import { dayDir } from "../store";
import { c, result, say } from "../ui";

const ms = (n: number) => (n < 1000 ? `${n.toFixed(0)}ms` : `${(n / 1000).toFixed(2)}s`);

function showLog(log: string) {
  const lines = log.trimEnd().split("\n").filter(Boolean);
  if (!lines.length) return;
  const shown = lines.length > 20 ? [...lines.slice(0, 20), `… ${lines.length - 20} more lines`] : lines;
  say(c.dim(shown.map((l) => `  │ ${l}`).join("\n")));
}

export interface ExampleOutcome {
  index: number;
  expected: string;
  answer?: string;
  pass: boolean;
  ms: number;
  log: string;
  auto?: boolean;
}

/** Runs examples that have an expected value for the part. Returns null when there are none. */
export async function test(s: Session, opts: { quiet?: boolean } = {}): Promise<ExampleOutcome[] | null> {
  const { t, part } = s;
  const cases = loadExamples(t.year, t.day)
    .map((ex, i) => ({ ex, i: i + 1, want: expected(ex, part) }))
    .filter((x) => x.want !== undefined);
  if (!cases.length) return null;

  const r = await prepared(s);
  const outcomes: ExampleOutcome[] = [];
  for (const { ex, i, want } of cases) {
    const res = await r.run(exampleInput(t.year, t.day, ex), { part, args: ex.args, example: true });
    const pass = res.ok && res.answer === want;
    outcomes.push({ index: i, expected: want!, answer: res.answer, pass, ms: res.ms, log: res.log, auto: ex.auto });
    if (!opts.quiet) {
      const mark = pass ? c.green("✓") : c.red("✗");
      const got = res.ok ? res.answer : c.red(`exit ${res.code}`);
      say(`${mark} example ${i}  want ${c.bold(want!)}  got ${c.bold(got ?? "nothing")}  ${c.dim(ms(res.ms))}${ex.auto ? c.dim("  (auto-extracted)") : ""}`);
      if (!pass || res.log.trim()) showLog(res.log);
    }
  }
  return outcomes;
}

export async function testCommand(s: Session, opts: { fallbackToReal?: boolean } = {}) {
  say(c.dim(`${s.t.year} day ${s.t.day} · part ${s.part} · ${s.lang.name}`));
  const outcomes = await test(s);
  if (!outcomes && opts.fallbackToReal) {
    say(c.yellow(`No part ${s.part} examples with expected answers yet, running real input.`));
    return runCommand(s);
  }
  if (!outcomes) {
    result(
      { ...s.t, part: s.part, lang: s.lang.id, examples: [] },
      c.yellow(`No examples with an expected part ${s.part} answer. Add one: aoc ex add p${s.part} <expected>  (or edit examples.toml)`),
    );
    return;
  }
  const passed = outcomes.filter((o) => o.pass).length;
  result(
    { ...s.t, part: s.part, lang: s.lang.id, examples: outcomes, pass: passed === outcomes.length },
    passed === outcomes.length ? c.green(`all ${passed} example(s) pass`) : c.red(`${outcomes.length - passed}/${outcomes.length} failing`),
  );
  if (passed !== outcomes.length) process.exitCode = 1;
}

export interface RealRun extends RunResult {
  accepted?: string;
  match?: boolean;
}

/** Real input. */
export async function runReal(s: Session): Promise<RealRun> {
  const file = join(dayDir(s.t.year, s.t.day), "input.txt");
  if (!existsSync(file)) {
    const { input } = await import("../api");
    await input(s.t.year, s.t.day);
  }
  const r = await prepared(s);
  const res = await r.run(readFileSync(file, "utf8"), { part: s.part, example: false });
  const accepted = s.state.parts[s.part].answer;
  return { ...res, accepted, match: accepted === undefined ? undefined : res.answer === accepted };
}

export async function runCommand(s: Session) {
  say(c.dim(`${s.t.year} day ${s.t.day} · part ${s.part} · ${s.lang.name} · input.txt`));
  const res = await runReal(s);
  showLog(res.log);
  if (!res.ok) {
    result({ ...s.t, part: s.part, lang: s.lang.id, ...res }, c.red(`✗ exit ${res.code}`));
    process.exitCode = 1;
    return;
  }
  const verdict =
    res.match === true ? c.green(" ✓ matches accepted answer") : res.match === false ? c.red(` ✗ accepted answer is ${res.accepted}`) : c.dim("  (unsubmitted: aoc submit)");
  result({ ...s.t, part: s.part, lang: s.lang.id, ...res }, `⭐ ${c.bold(res.answer!)}  ${c.dim(ms(res.ms))}${verdict}`);
  if (res.match === false) process.exitCode = 1;
}
