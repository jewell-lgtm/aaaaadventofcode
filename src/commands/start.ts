import * as api from "../api";
import type { Args } from "../args";
import { dayDir, loadDay, saveDay, type Target } from "../store";
import { syncPuzzle } from "../sync";
import { c, say, warn } from "../ui";

/** Ensures the day exists locally: day.json, puzzle.md, examples, input. Idempotent. */
export async function start(t: Target, _args: Args, opts: { quiet?: boolean } = {}) {
  const initial = loadDay(t.year, t.day);
  const fresh = initial.startedAt === undefined;
  if (fresh) saveDay({ ...initial, startedAt: new Date().toISOString() });

  await syncPuzzle(t).catch((e) => warn(`puzzle: ${e.message}`));
  await api.input(t.year, t.day).catch((e) => warn(`input: ${e.message}`));

  const { title } = loadDay(t.year, t.day);
  if (fresh) say(c.green(`✦ started ${t.year} day ${t.day}${title ? `: ${title}` : ""}`));
  if (!opts.quiet) say(c.dim(dayDir(t.year, t.day)));
}
