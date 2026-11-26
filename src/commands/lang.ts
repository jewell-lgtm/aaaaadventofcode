import type { Args } from "../args";
import { getLang, langs } from "../langs";
import { pruneContainers } from "../runner";
import { scaffold } from "../scaffold";
import { pickLang } from "../session";
import { loadDay, saveDay, type Target } from "../store";
import { c, result, say } from "../ui";

/** `aoc lang` shows, `aoc lang rust` switches, `aoc lang repick` asks JEV for something else. */
export async function langCommand(t: Target, args: Args) {
  const state = loadDay(t.year, t.day);
  const want = args.rest[0];
  if (want) {
    const pick = want === "repick" ? await pickLang(state, state.lang ? [state.lang] : []) : { lang: getLang(want), reason: "chosen by you" };
    const { lang } = pick;
    state.lang = lang.id;
    state.langReason = pick.reason;
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
