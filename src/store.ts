import { existsSync, mkdirSync, readdirSync, readFileSync, writeFileSync } from "fs";
import { dirname, join, relative, sep } from "path";
import { isFinalDay } from "./calendar";

export const ROOT = join(import.meta.dir, "..");
/** solutions/ normally; gallery/ under `aoc gallery …`. Same YYYY/dayDD/<lang> layout. */
export let SOLUTIONS = join(ROOT, "solutions");
export function useGallery() {
  SOLUTIONS = join(ROOT, "gallery");
}
const STATE_FILE = join(ROOT, ".aoc", "state.json");

export type Part = 1 | 2;

export type Verdict = "correct" | "wrong" | "high" | "low" | "wait" | "done" | "unknown";

export interface Submission {
  answer: string;
  verdict: Verdict;
  at: string;
  /** AoC cooldown after this attempt. */
  waitUntil?: string;
}

export interface PartState {
  /** Accepted answer. Presence = star earned. */
  answer?: string;
  solvedAt?: string;
  submissions: Submission[];
}

export interface DayState {
  year: number;
  day: number;
  title?: string;
  lang?: string;
  langReason?: string;
  startedAt?: string;
  parts: Record<Part, PartState>;
}

export interface Target {
  year: number;
  day: number;
}

export const pad = (day: number) => String(day).padStart(2, "0");

export function dayDir(year: number, day: number): string {
  return join(SOLUTIONS, String(year), `day${pad(day)}`);
}

export function emptyDay(year: number, day: number): DayState {
  return { year, day, parts: { 1: { submissions: [] }, 2: { submissions: [] } } };
}

export function loadDay(year: number, day: number): DayState {
  const file = join(dayDir(year, day), "day.json");
  if (!existsSync(file)) return emptyDay(year, day);
  const raw = JSON.parse(readFileSync(file, "utf8")) as DayState;
  const base = emptyDay(year, day);
  return { ...base, ...raw, parts: { 1: { ...base.parts[1], ...raw.parts?.[1] }, 2: { ...base.parts[2], ...raw.parts?.[2] } } };
}

export function saveDay(state: DayState): void {
  const dir = dayDir(state.year, state.day);
  mkdirSync(dir, { recursive: true });
  writeFileSync(join(dir, "day.json"), JSON.stringify(state, null, 2) + "\n");
}

export const isAttempted = (s: DayState) => s.startedAt !== undefined;

export function stars(s: DayState): number {
  const p1 = s.parts[1].answer !== undefined;
  const p2 = s.parts[2].answer !== undefined || (p1 && isFinalDay(s.year, s.day));
  return Number(p1) + Number(p2);
}

export const isComplete = (s: DayState) => stars(s) === 2;

/** First part without a star (final day only has part 1). */
export function currentPart(s: DayState): Part {
  return s.parts[1].answer === undefined || isFinalDay(s.year, s.day) ? 1 : 2;
}

/** Day targeted by a path inside solutions/YYYY/dayDD, if any. */
export function targetFromPath(path: string): Target | null {
  const rel = relative(SOLUTIONS, path);
  if (rel.startsWith("..")) return null;
  const [y, d] = rel.split(sep);
  const m = d?.match(/^day(\d{2})$/);
  return /^\d{4}$/.test(y ?? "") && m ? { year: Number(y), day: Number(m[1]) } : null;
}

export function listDays(year: number): DayState[] {
  const dir = join(SOLUTIONS, String(year));
  if (!existsSync(dir)) return [];
  return readdirSync(dir)
    .filter((n) => /^day\d{2}$/.test(n))
    .sort()
    .map((n) => loadDay(year, Number(n.slice(3))));
}

export function listYears(): number[] {
  if (!existsSync(SOLUTIONS)) return [];
  return readdirSync(SOLUTIONS).filter((n) => /^\d{4}$/.test(n)).map(Number).sort();
}

export interface GlobalState {
  last?: Target;
}

export function loadGlobal(): GlobalState {
  return existsSync(STATE_FILE) ? JSON.parse(readFileSync(STATE_FILE, "utf8")) : {};
}

export function saveGlobal(state: GlobalState): void {
  mkdirSync(dirname(STATE_FILE), { recursive: true });
  writeFileSync(STATE_FILE, JSON.stringify(state, null, 2) + "\n");
}
