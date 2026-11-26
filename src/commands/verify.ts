import { existsSync, readdirSync, statSync } from "fs";
import { join } from "path";
import { findLang, type Lang } from "../langs";
import { runReal } from "./test";
import { dayDir, listDays, listYears, type Part } from "../store";
import { c, result, say } from "../ui";

export interface VerifyRow {
  year: number;
  day: number;
  part: Part;
  lang: string;
  expected: string;
  answer?: string;
  pass: boolean;
  ms: number;
}

/** Every solved part × every language dir present in that day, against the accepted answer. */
export async function verifyCommand(year: number | undefined, langFilter: string | undefined) {
  const rows: VerifyRow[] = [];
  const broken = new Map<string, string>(); // lang id → build error, so a broken image fails fast
  for (const y of year ? [year] : listYears()) {
    for (const state of listDays(y)) {
      if (!existsSync(join(dayDir(y, state.day), "input.txt"))) continue;
      const langs = [...new Set([state.lang, ...langDirs(y, state.day)])]
        .map((id) => findLang(id))
        .filter((l): l is Lang => !!l && (!langFilter || l.id === findLang(langFilter)?.id));
      for (const part of [1, 2] as Part[]) {
        const expected = state.parts[part].answer;
        if (expected === undefined) continue;
        for (const lang of langs) {
          const s = { t: { year: y, day: state.day }, state, lang, part, dir: join(dayDir(y, state.day), lang.id) };
          const res = broken.has(lang.id)
            ? { ok: false, answer: undefined, ms: 0, log: broken.get(lang.id)! }
            : await runReal(s).catch((e) => {
                if (e.name === "AocError" && /build failed/.test(e.message) && /docker/.test(e.message)) broken.set(lang.id, e.message);
                return { ok: false, answer: undefined, ms: 0, log: String(e.message ?? e) };
              });
          const pass = res.answer === expected;
          const why = pass ? "" : res.log.trim().split("\n").filter((l) => /error|exception|failed/i.test(l)).at(0) ?? res.log.trim().split("\n").at(-1) ?? "";
          rows.push({ year: y, day: state.day, part, lang: lang.id, expected, answer: res.answer, pass, ms: res.ms });
          say(`${pass ? c.green("✓") : c.red("✗")} ${y} ${String(state.day).padStart(2)} p${part} ${lang.id.padEnd(10)} ${c.dim(`${res.ms.toFixed(0)}ms`)}${pass ? "" : `  want ${expected} got ${res.answer ?? c.red("error")}${res.answer ? "" : c.dim(`  ${why.trim().slice(0, 140)}`)}`}`);
        }
      }
    }
  }
  const failed = rows.filter((r) => !r.pass).length;
  result({ rows, pass: failed === 0 }, failed ? c.red(`${failed}/${rows.length} failing`) : c.green(`all ${rows.length} pass`));
  if (failed) process.exitCode = 1;
}

function langDirs(year: number, day: number): string[] {
  const dir = dayDir(year, day);
  return readdirSync(dir).filter((n) => findLang(n) && statSync(join(dir, n)).isDirectory());
}
