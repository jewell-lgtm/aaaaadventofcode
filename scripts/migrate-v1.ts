#!/usr/bin/env bun
// One-shot: v1 layout (part1.ts, Part1.hs, part1.py, expected-partN.txt, example*.txt in the day dir)
// → v2 (day.json, <lang>/ subdirs from templates, examples.toml). Idempotent: skips days with day.json.
// Usage: bun scripts/migrate-v1.ts [--dry]
import { existsSync, readdirSync, readFileSync, rmSync, writeFileSync } from "fs";
import { join, relative } from "path";
import { saveExamples, writeExampleFile, type Example } from "../src/examples";
import { getLang } from "../src/langs";
import { scaffold } from "../src/scaffold";
import { emptyDay, listYears, ROOT, saveDay, SOLUTIONS } from "../src/store";

const dry = process.argv.includes("--dry");

const LANG_OF: [RegExp, string][] = [
  [/\.ts$/, "ts"],
  [/\.py$/, "python"],
  [/^Part\d.*\.hs$/, "haskell"],
];

function firstCommit(path: string): string | undefined {
  const r = Bun.spawnSync(["git", "log", "--diff-filter=A", "--format=%cI", "--", relative(ROOT, path)], { cwd: ROOT });
  return r.stdout.toString().trim().split("\n").filter(Boolean).at(-1);
}

const read = (p: string) => (existsSync(p) ? readFileSync(p, "utf8").trim() : undefined);

for (const year of listYears()) {
  for (const name of readdirSync(join(SOLUTIONS, String(year))).filter((n) => /^day\d{2}$/.test(n)).sort()) {
    const day = Number(name.slice(3));
    const dir = join(SOLUTIONS, String(year), name);
    if (existsSync(join(dir, "day.json"))) continue;
    const files = readdirSync(dir);
    const byLang = new Map<string, string[]>();
    for (const f of files) {
      const id = LANG_OF.find(([re]) => re.test(f))?.[1];
      if (id) byLang.set(id, [...(byLang.get(id) ?? []), f]);
    }
    const primary = byLang.has("ts") ? "ts" : [...byLang.keys()][0];
    const state = emptyDay(year, day);
    state.lang = primary;
    state.langReason = "migrated from v1";
    state.startedAt = firstCommit(dir) ?? new Date().toISOString();
    for (const part of [1, 2] as const) {
      const answer = read(join(dir, `expected-part${part}.txt`));
      if (answer !== undefined) Object.assign(state.parts[part], { answer, solvedAt: state.startedAt });
    }

    const examples: Example[] = [];
    for (const f of files.filter((f) => /^example\d*\.txt$/.test(f)).sort()) {
      const base = f.replace(/\.txt$/, "");
      const ex: Example = { part1: read(join(dir, `expected-${base}-part1.txt`)) ?? "", part2: read(join(dir, `expected-${base}-part2.txt`)) ?? "", auto: false };
      if (!dry) ex.input = writeExampleFile(year, day, examples.length + 1, readFileSync(join(dir, f), "utf8"));
      examples.push(ex);
    }

    console.log(`${year}/${name}: ${[...byLang].map(([l, fs]) => `${l}[${fs.join(",")}]`).join(" ")} ★${Number(!!state.parts[1].answer) + Number(!!state.parts[2].answer)} ex${examples.length}`);
    if (dry) continue;

    for (const [id, fs] of byLang) {
      const lang = getLang(id);
      const { dir: langDir } = scaffold({ year, day }, lang);
      for (const f of fs) {
        let text = readFileSync(join(dir, f), "utf8");
        // Cross-day imports: "../day10/part2" → "../../day10/ts/part2"
        if (id === "ts") text = text.replace(/from "\.\.\/(day\d{2})\/([^"]+)"/g, `from "../../$1/ts/$2"`);
        writeFileSync(join(langDir, f), text);
        rmSync(join(dir, f));
      }
    }
    for (const f of files) {
      if (/^(expected-.*|example\d*)\.txt$/.test(f) || f === "Runner.hs") rmSync(join(dir, f), { force: true });
    }
    if (examples.length) saveExamples(year, day, examples);
    saveDay(state);
  }
}
