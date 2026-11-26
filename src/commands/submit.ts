import { relative } from "path";
import * as api from "../api";
import type { Args } from "../args";
import { isFinalDay } from "../calendar";
import type { Session } from "../session";
import { dayDir, loadDay, ROOT, saveDay } from "../store";
import { syncPuzzle } from "../sync";
import { c, isJson, result, say, warn } from "../ui";
import { parseVerdict, refuse } from "../verdict";
import { runReal, test } from "./test";

class SubmitError extends Error {
  name = "AocError";
}

async function confirm(question: string): Promise<boolean> {
  if (!process.stdin.isTTY) return false;
  process.stdout.write(`${question} [y/N] `);
  for await (const line of console) return /^y(es)?$/i.test(line.trim());
  return false;
}

async function commit(s: Session) {
  const dir = dayDir(s.t.year, s.t.day);
  const msg = `${s.t.year}: day${String(s.t.day).padStart(2, "0")} part ${s.part} (${s.lang.id})`;
  const git = (...a: string[]) => Bun.spawnSync(["git", ...a], { cwd: ROOT, stdout: "pipe", stderr: "pipe" });
  git("add", relative(ROOT, dir));
  const r = git("commit", "-m", msg, "--", relative(ROOT, dir));
  if (r.exitCode !== 0) return warn(`git commit failed: ${r.stderr.toString().trim() || r.stdout.toString().trim()}`);
  say(c.dim(`git: ${msg}`));
  if (api.env("AOC_PUSH") === "1") {
    const p = git("push");
    if (p.exitCode !== 0) warn(`git push failed: ${p.stderr.toString().trim()}`);
  }
}

export async function submitCommand(s: Session, args: Args) {
  const { t, part } = s;

  const examples = await test(s, { quiet: true });
  const failing = examples?.filter((e) => !e.pass) ?? [];
  if (failing.length && !args.force) {
    throw new SubmitError(`${failing.length} example(s) failing (${failing.map((f) => `#${f.index}: want ${f.expected} got ${f.answer ?? "error"}`).join(", ")}). aoc submit -f to send anyway.`);
  }

  const run = await runReal(s);
  if (!run.ok) throw new SubmitError(`solution exited ${run.code}:\n${run.log}`);
  const answer = run.answer!;
  const state = loadDay(t.year, t.day);
  const p = state.parts[part];

  const why = refuse(p, answer, Date.now(), part);
  if (why) {
    if (p.answer !== undefined) return result({ ...t, part, answer, verdict: p.answer === answer ? "accepted" : "mismatch" }, p.answer === answer ? c.green(`✓ ${why}`) : c.red(`✗ ${why}`));
    throw new SubmitError(`not submitting: ${why}`);
  }

  say(`${t.year} day ${t.day} part ${part} (${s.lang.name}): ${c.bold(answer)}  ${c.dim(`examples ${examples ? `${examples.length - failing.length}/${examples.length}` : "none"}`)}`);
  if (!args.yes && !isJson() && !(await confirm("Submit?"))) return result({ ...t, part, answer, verdict: "skipped" }, c.dim("not submitted"));

  const v = parseVerdict(await api.submit(t.year, t.day, part, answer));
  const at = new Date().toISOString();
  p.submissions.push({ answer, verdict: v.verdict, at, waitUntil: v.waitSeconds ? new Date(Date.now() + v.waitSeconds * 1000).toISOString() : undefined });
  if (v.verdict === "correct") Object.assign(p, { answer, solvedAt: at });
  saveDay(state);

  if (v.verdict === "correct" || v.verdict === "done") {
    // Fresh page: part 2 text and examples, or (for "done") the answers you already have on the site.
    await syncPuzzle(t, true).catch((e) => warn(`puzzle refresh: ${e.message}`));
  }
  const after = loadDay(t.year, t.day).parts[part];

  const lines: Record<string, string> = {
    correct: c.green(`⭐ correct!${part === 1 && !isFinalDay(t.year, t.day) ? " Part 2 is in puzzle.md; run `aoc` for its tests." : ""}`),
    done: after.answer === answer ? c.green(`✓ already solved on the site with this answer`) : c.yellow(`already solved on the site${after.answer ? ` as ${after.answer}` : ""}`),
    high: c.red(`✗ too high`),
    low: c.red(`✗ too low`),
    wrong: c.red(`✗ wrong`),
    wait: c.yellow(`⏳ too soon`),
    unknown: c.yellow(v.message),
  };
  const waitNote = v.waitSeconds ? c.dim(`  (wait ${v.waitSeconds}s)`) : "";
  if (v.verdict === "correct") await commit(s);
  result({ ...t, part, answer, verdict: v.verdict, waitSeconds: v.waitSeconds, message: v.message }, lines[v.verdict] + waitNote);
  if (!["correct", "done"].includes(v.verdict)) process.exitCode = 1;
}
