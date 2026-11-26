import { cpSync, existsSync, readdirSync, readFileSync, statSync, writeFileSync } from "fs";
import { join } from "path";
import { LANGS_DIR, type Lang } from "./langs";
import { dayDir, pad, type Target } from "./store";

export const langDir = (t: Target, lang: Lang) => join(dayDir(t.year, t.day), lang.id);

/** Copies langs/<id>/template into the day's <id>/ dir. Never overwrites. */
export function scaffold(t: Target, lang: Lang): { dir: string; created: boolean } {
  const dir = langDir(t, lang);
  if (existsSync(dir)) return { dir, created: false };
  const template = join(LANGS_DIR, lang.id, "template");
  cpSync(template, dir, { recursive: true });
  const vars: Record<string, string> = { year: String(t.year), day: String(t.day), dd: pad(t.day) };
  const walk = (d: string) => {
    for (const name of readdirSync(d)) {
      const p = join(d, name);
      if (statSync(p).isDirectory()) walk(p);
      else {
        const text = readFileSync(p, "utf8");
        const out = text.replace(/\{\{(year|day|dd)\}\}/g, (_, k) => vars[k]);
        if (out !== text) writeFileSync(p, out);
      }
    }
  };
  walk(dir);
  if (lang.ignore?.length) writeFileSync(join(dir, ".gitignore"), lang.ignore.join("\n") + "\n");
  return { dir, created: true };
}
