import { cpSync, existsSync, readdirSync, readFileSync, statSync, writeFileSync } from "fs";
import { join } from "path";
import { LANGS_DIR, type Lang } from "./langs";
import { dayDir, pad, type Target } from "./store";

export const langDir = (t: Target, lang: Lang) => join(dayDir(t.year, t.day), lang.id);

function render(text: string, t: Target): string {
  const vars: Record<string, string> = { year: String(t.year), day: String(t.day), dd: pad(t.day) };
  return text.replace(/\{\{(year|day|dd)\}\}/g, (_, k) => vars[k]);
}

/** A part's solution file is still exactly the scaffolded template: you haven't started it. */
export function untouched(t: Target, lang: Lang, part: 1 | 2): boolean {
  const mine = join(langDir(t, lang), lang.solution[part]);
  if (!existsSync(mine)) return true;
  const template = join(LANGS_DIR, lang.id, "template", lang.solution[part]);
  return existsSync(template) && readFileSync(mine, "utf8") === render(readFileSync(template, "utf8"), t);
}

/**
 * Start part 2 from part 1: copy the part 1 solution over an untouched part 2, renaming
 * part1/Part1/PART1 identifiers (Haskell modules, Java classes, C++ namespaces…). Returns true if copied.
 */
export function carryPart1(t: Target, lang: Lang): boolean {
  const [from, to] = [join(langDir(t, lang), lang.solution[1]), join(langDir(t, lang), lang.solution[2])];
  if (from === to || !existsSync(from) || !untouched(t, lang, 2) || untouched(t, lang, 1)) return false;
  const text = readFileSync(from, "utf8").replace(/\b(part|Part|PART)(_?)1\b/g, "$1$22");
  writeFileSync(to, text);
  return true;
}

/** Copies langs/<id>/template into the day's <id>/ dir. Never overwrites. */
export function scaffold(t: Target, lang: Lang): { dir: string; created: boolean } {
  const dir = langDir(t, lang);
  if (existsSync(dir)) return { dir, created: false };
  const template = join(LANGS_DIR, lang.id, "template");
  cpSync(template, dir, { recursive: true });
  const walk = (d: string) => {
    for (const name of readdirSync(d)) {
      const p = join(d, name);
      if (statSync(p).isDirectory()) walk(p);
      else {
        const text = readFileSync(p, "utf8");
        const out = render(text, t);
        if (out !== text) writeFileSync(p, out);
      }
    }
  };
  walk(dir);
  if (lang.ignore?.length) writeFileSync(join(dir, ".gitignore"), lang.ignore.join("\n") + "\n");
  return { dir, created: true };
}
