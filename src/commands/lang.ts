import type { Args } from "../args";
import { getLang, langs } from "../langs";
import { pruneContainers } from "../runner";
import { scaffold } from "../scaffold";
import { loadDay, saveDay, type Target } from "../store";
import { c, result, say } from "../ui";

/** `aoc lang` shows, `aoc lang rust` switches. `aoc lang repick` is wired in with JEV. */
export async function langCommand(t: Target, args: Args, repick?: (t: Target) => Promise<void>) {
  const state = loadDay(t.year, t.day);
  const want = args.rest[0];
  if (want === "repick") {
    if (!repick) throw new Error("repick needs JEV");
    return repick(t);
  }
  if (want) {
    const lang = getLang(want);
    state.lang = lang.id;
    state.langReason = "chosen by you";
    saveDay(state);
    const { dir } = scaffold(t, lang);
    return result({ ...t, lang: lang.id, dir }, c.green(`${t.year} day ${t.day} → ${lang.name}  ${c.dim(dir)}`));
  }
  result(
    { ...t, lang: state.lang, reason: state.langReason },
    state.lang ? `${getLang(state.lang).name}${state.langReason ? c.dim(`: ${state.langReason}`) : ""}` : "no language yet",
  );
}

export async function langsCommand(args: Args) {
  if (args.rest[0] === "prune") {
    const removed = await pruneContainers();
    say(c.dim(`removed containers: ${removed.join(" ") || "none"}`));
    say(c.dim("images kept; remove with: docker images 'aoc-*' -q | xargs docker rmi"));
    return result({ removed });
  }
  const all = langs();
  result(
    { langs: all.map(({ id, name, specialist, criteria }) => ({ id, name, specialist: !!specialist, criteria })) },
    all.map((l) => `${c.bold(l.id.padEnd(12))}${l.specialist ? c.yellow("specialist ") : ""}${c.dim(l.criteria)}`).join("\n"),
  );
}
