import { existsSync, readdirSync, readFileSync } from "fs";
import { join } from "path";
import { ROOT } from "./store";

export const LANGS_DIR = join(ROOT, "langs");

/**
 * langs/<id>/lang.json. Each language is a folder:
 *   lang.json   this
 *   Dockerfile  toolchain image (pinned version)
 *   template/   copied to solutions/YYYY/dayDD/<id>/; {{year}} {{day}} {{dd}} substituted
 * Inside the container, cwd = the day's <id>/ dir. stdin = puzzle input.
 * env: AOC_PART=1|2, AOC_ARGS=<json object>, AOC_EXAMPLE=1|0.
 * The answer is the last non-empty stdout line; everything else is shown as log.
 */
export interface Lang {
  id: string;
  name: string;
  aliases?: string[];
  /** One line for JEV: what puzzles this language is great for. */
  criteria: string;
  /** Only pick on a strong fit (R, octave, sql, jq). */
  specialist?: boolean;
  /** Files you edit, relative to the lang dir, per part. Opened by nvim. */
  solution: { 1: string; 2: string };
  /** Shell, run before each run. Should be incremental/fast when nothing changed. */
  build?: string;
  /** Shell, reads stdin. */
  run: string;
  /** Container path → named volume suffix, for package/build caches. */
  caches?: Record<string, string>;
  /** Paths (relative to lang dir) to gitignore: build outputs. */
  ignore?: string[];
}

let cache: Lang[] | undefined;

export function langs(): Lang[] {
  cache ??= existsSync(LANGS_DIR)
    ? readdirSync(LANGS_DIR)
        .filter((id) => existsSync(join(LANGS_DIR, id, "lang.json")))
        .sort()
        .map((id) => ({ ...JSON.parse(readFileSync(join(LANGS_DIR, id, "lang.json"), "utf8")), id }) as Lang)
    : [];
  return cache;
}

export function findLang(name: string | undefined): Lang | undefined {
  if (!name) return undefined;
  const n = name.toLowerCase();
  return langs().find((l) => l.id === n || l.aliases?.includes(n));
}

export class LangError extends Error {
  name = "AocError";
}

export function getLang(name: string): Lang {
  const lang = findLang(name);
  if (!lang) throw new LangError(`Unknown language "${name}". Bank: ${langs().map((l) => l.id).join(", ")}`);
  return lang;
}

/** --lang › AOC_LANG › LANG (only when it names a bank language, since LANG is usually a locale). */
export function langOverride(flag: string | undefined, env = process.env): Lang | undefined {
  if (flag) return getLang(flag);
  if (env.AOC_LANG) return getLang(env.AOC_LANG);
  return findLang(env.LANG);
}
