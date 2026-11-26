import type { Args } from "./args";
import { getLang, langOverride, type Lang } from "./langs";
import { runner, type Runner } from "./runner";
import { langDir, scaffold } from "./scaffold";
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

/** Language for a day: override › day.json › pick (JEV, wired later) › ts. */
export async function resolveLang(state: DayState, args: Args, pick?: (s: DayState) => Promise<Lang | undefined>): Promise<Lang> {
  const override = langOverride(args.lang);
  if (override) return override;
  if (state.lang) return getLang(state.lang);
  return (await pick?.(state)) ?? getLang("ts");
}

export async function session(t: Target, args: Args, pick?: (s: DayState) => Promise<Lang | undefined>): Promise<Session> {
  const state = loadDay(t.year, t.day);
  const lang = await resolveLang(state, args, pick);
  // A one-off --lang doesn't switch the day's language (that's `aoc lang X`); it only sets it on a fresh day.
  if (!state.lang) {
    state.lang = lang.id;
    saveDay(state);
  }
  const { dir, created } = scaffold(t, lang);
  if (created) say(c.green(`✦ scaffolded ${lang.name} → ${dir}`));
  const part = args.part ?? currentPart(state);
  return { t, state, lang, part, dir: langDir(t, lang) };
}

export async function prepared(s: Session): Promise<Runner> {
  const r = await runner(s.lang, s.dir);
  await r.build();
  return r;
}
