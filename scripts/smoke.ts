#!/usr/bin/env bun
// Per-language smoke test: every machine-gallery puzzle × part × language against its examples.
// Usage: bun scripts/smoke.ts [lang …]
import { readdirSync } from "fs";
import { join } from "path";
import { langs } from "../src/langs";
import { ROOT } from "../src/store";

const only = process.argv.slice(2);
const gallery = join(ROOT, "machine-gallery");
const days = readdirSync(gallery)
  .filter((y) => /^\d{4}$/.test(y))
  .flatMap((y) => readdirSync(join(gallery, y)).filter((d) => /^day\d{2}$/.test(d)).map((d) => [y, String(Number(d.slice(3)))] as const));

let failed = 0;
for (const lang of langs().filter((l) => !only.length || only.includes(l.id))) {
  const fails: string[] = [];
  const t0 = performance.now();
  for (const [y, d] of days) {
    for (const p of ["p1", "p2"]) {
      const r = Bun.spawnSync(["bun", join(ROOT, "src/cli.ts"), "gallery", "test", y, d, p, "--lang", lang.id, "--json"], { stderr: "pipe" });
      const out = r.stdout.toString().trim().split("\n").at(-1) ?? "";
      let pass = false;
      try {
        pass = JSON.parse(out).pass === true;
      } catch {}
      if (!pass) fails.push(`${y}/${d}${p}`);
    }
  }
  failed += fails.length;
  console.log(`${fails.length ? "✗" : "✓"} ${lang.id.padEnd(12)} ${days.length * 2 - fails.length}/${days.length * 2}  ${((performance.now() - t0) / 1000).toFixed(0)}s${fails.length ? `  ${fails.join(" ")}` : ""}`);
}
process.exit(failed ? 1 : 0);
