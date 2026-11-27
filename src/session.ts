import type { Args } from "./args";
import { fallbackPick, jevPick, type Pick } from "./jev";
import { getLang, langOverride, type Lang } from "./langs";
import { runner, type Runner } from "./runner";
import { carryPart1, langDir, scaffold } from "./scaffold";
import { currentPart, loadDay, saveDay, type DayState, type Part, type Target } from "./store";
import { c, say } from "./ui";

export class AocError extends Error {
  name = "AocError";
}

export interface Session {
  t: Target;
  state: DayState;
  lang: Lang;
  part: Part;
  dir: string;
}

/** JEV, or a random fresh language when it's unreachable. */
export async function pickLang(state: DayState, exclude: string[] = []): Promise<Pick> {
  say(c.dim("🎲 asking JEV for a language…"));
  const pick = (await jevPick(state, exclude)) ?? fallbackPick(state, exclude);
  say(`🎲 ${c.bold(pick.lang.name)}  ${c.dim(pick.reason)}`);
  return pick;
}

/** Language for a day: --lang/AOC_LANG/LANG › day.json › JEV. */
async function resolveLang(state: DayState, args: Args): Promise<Lang> {
  const override = langOverride(args.lang);
  if (override) return override;
  if (state.lang) return getLang(state.lang);
  const pick = await pickLang(state);
  state.langReason = pick.reason;
  return pick.lang;
}

export async function session(t: Target, args: Args): Promise<Session> {
  const state = loadDay(t.year, t.day);
  const lang = await resolveLang(state, args);
  // A one-off --lang doesn't switch the day's language (that's `aoc lang X`); it only sets it on a fresh day.
  if (!state.lang) {
    state.lang = lang.id;
    saveDay(state);
  }
  const { dir, created } = scaffold(t, lang);
  if (created) say(c.green(`✦ scaffolded ${lang.name} → ${dir}`));
  const part = args.part ?? currentPart(state);
  // On part 2 with an untouched part 2 file: start from your part 1 solution.
  if (part === 2 && state.parts[1].answer !== undefined && carryPart1(t, lang)) {
    say(c.green(`✦ copied part 1 → ${lang.solution[2]} to start part 2`));
  }
  return { t, state, lang, part, dir: langDir(t, lang) };
}

export async function prepared(s: Session): Promise<Runner> {
  const r = await runner(s.lang, s.dir);
  await r.build(s.part);
  return r;
}
