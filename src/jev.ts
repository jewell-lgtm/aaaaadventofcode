// JEV: OpenRouter "systemone" structured-judgement endpoint. Same call shape as
// local-assistent's inbox_zero.py: {model, state, questions} → {answers: {q: {choice, confidence}}}.
import { existsSync, readFileSync } from "fs";
import { join } from "path";
import { env } from "./api";
import { langs, type Lang } from "./langs";
import { dayDir, listDays, type DayState } from "./store";

const URL = "https://openrouter.ai/api/v1/systemone";
const MODEL = "typesafe/jev-1.13";
/** Languages used on the previous N days are off the table, which keeps the variety honest. */
const COOLDOWN_DAYS = 3;

export interface Pick {
  lang: Lang;
  confidence?: number;
  reason: string;
}

function key(): string | undefined {
  const k = env("OPENROUTER_API_KEY");
  if (k) return k;
  const r = Bun.spawnSync(["security", "find-generic-password", "-s", "openrouter-api-key", "-w"], { stderr: "ignore" });
  return r.exitCode === 0 ? r.stdout.toString().trim() || undefined : undefined;
}

export interface Candidates {
  choices: Lang[];
  recent: string[];
  usedThisYear: string[];
}

/** Bank minus recently used languages (and `exclude`); falls back to the whole bank if that empties it. */
export function candidates(state: DayState, history: DayState[], exclude: string[] = []): Candidates {
  const before = history.filter((d) => d.day < state.day && d.lang).sort((a, b) => b.day - a.day);
  const recent = [...new Set(before.slice(0, COOLDOWN_DAYS).map((d) => d.lang!))];
  const usedThisYear = [...new Set(history.filter((d) => d.lang && d.day !== state.day).map((d) => d.lang!))];
  const all = langs();
  const choices = all.filter((l) => !recent.includes(l.id) && !exclude.includes(l.id));
  return { choices: choices.length ? choices : all, recent, usedThisYear };
}

export function questions(c: Candidates) {
  return {
    language: {
      type: "choice",
      instructions:
        "Which programming language would be the most satisfying, natural fit for solving this Advent of Code puzzle? " +
        "Weigh how well the language's strengths match the puzzle's core (parsing, grids, graph search, number crunching, recursion, simulation). " +
        `Prefer languages not used yet this year (${c.usedThisYear.join(", ") || "none so far"}) when the fit is close. ` +
        "Only pick a language marked SPECIALIST when the puzzle is squarely in its niche.",
      criteria: Object.fromEntries(c.choices.map((l) => [l.id, `${l.specialist ? "SPECIALIST. " : ""}${l.name}: ${l.criteria}`])),
    },
  };
}

function puzzleText(state: DayState): string {
  const f = join(dayDir(state.year, state.day), "puzzle.md");
  return existsSync(f) ? readFileSync(f, "utf8").slice(0, 8000) : `Advent of Code ${state.year} day ${state.day}: ${state.title ?? "untitled"}`;
}

/** Returns null when JEV isn't reachable, and the caller falls back. */
export async function jevPick(state: DayState, exclude: string[] = []): Promise<Pick | null> {
  const k = key();
  if (!k) return null;
  const c = candidates(state, listDays(state.year), exclude);
  const body = {
    model: MODEL,
    state: { puzzle: puzzleText(state), recently_used_languages: c.recent, used_this_year: c.usedThisYear },
    questions: questions(c),
  };
  for (let attempt = 0; attempt < 4; attempt++) {
    const res = await fetch(URL, {
      method: "POST",
      headers: { Authorization: `Bearer ${k}`, "Content-Type": "application/json" },
      body: JSON.stringify(body),
      signal: AbortSignal.timeout(60_000),
    }).catch(() => null);
    if (res?.ok) {
      const a = ((await res.json()) as { answers?: { language?: { choice?: string; confidence?: number } } }).answers?.language;
      const lang = c.choices.find((l) => l.id === a?.choice);
      if (!lang) return null;
      return { lang, confidence: a?.confidence, reason: `JEV pick (confidence ${a?.confidence?.toFixed(2) ?? "?"}; skipped recent: ${c.recent.join(", ") || "none"})` };
    }
    if (res && res.status !== 429 && res.status < 500) return null;
    await Bun.sleep(1000 * 2 ** attempt);
  }
  return null;
}

/** Offline fallback: random language from the candidates, preferring ones unused this year. */
export function fallbackPick(state: DayState, exclude: string[] = []): Pick {
  const c = candidates(state, listDays(state.year), exclude);
  const general = c.choices.filter((l) => !l.specialist);
  const fresh = general.filter((l) => !c.usedThisYear.includes(l.id));
  const pool = fresh.length ? fresh : general.length ? general : c.choices;
  return { lang: pool[Math.floor(Math.random() * pool.length)], reason: "random pick (JEV unavailable)" };
}
