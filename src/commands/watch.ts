import { watch } from "fs";
import type { Session } from "../session";
import { c, say } from "../ui";
import { testCommand } from "./test";

/** Rerun `aoc test` whenever a file in the language dir (or examples.toml) changes. */
export async function watchCommand(s: Session) {
  const ignored = (f: string) => (s.lang.ignore ?? []).some((i) => f.startsWith(i.replace(/\/$/, ""))) || f.includes("/.") || f.startsWith(".");
  let timer: Timer | undefined;
  let running = false;
  const rerun = () => {
    clearTimeout(timer);
    timer = setTimeout(async () => {
      if (running) return;
      running = true;
      console.clear();
      await testCommand(s).catch((e) => say(c.red(e.message)));
      say(c.dim(`\nwatching ${s.dir} (ctrl-c to stop)`));
      running = false;
    }, 150);
  };
  watch(s.dir, { recursive: true }, (_e, f) => f && !ignored(f) && rerun());
  watch(`${s.dir}/..`, (_e, f) => f === "examples.toml" && rerun());
  rerun();
  await new Promise(() => {});
}
