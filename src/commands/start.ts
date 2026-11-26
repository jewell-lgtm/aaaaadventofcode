import * as api from "../api";
import type { Args } from "../args";
import { dayDir, loadDay, saveDay, type Target } from "../store";
import { c, result, say, warn } from "../ui";

/** Ensures the day exists locally: day.json, puzzle, input. Idempotent. */
export async function start(t: Target, _args: Args) {
  const state = loadDay(t.year, t.day);
  const fresh = state.startedAt === undefined;
  state.startedAt ??= new Date().toISOString();

  try {
    const html = await api.puzzleHtml(t.year, t.day);
    state.title ??= html.match(/<h2>--- Day \d+: (.*?) ---<\/h2>/)?.[1];
  } catch (e) {
    warn(`puzzle: ${(e as Error).message}`);
  }
  try {
    await api.input(t.year, t.day);
  } catch (e) {
    warn(`input: ${(e as Error).message}`);
  }
  saveDay(state);

  if (fresh) say(c.green(`✦ started ${t.year} day ${t.day}${state.title ? `: ${state.title}` : ""}`));
  result({ ...t, dir: dayDir(t.year, t.day), title: state.title }, `${t.year} day ${t.day} → ${dayDir(t.year, t.day)}`);
}
