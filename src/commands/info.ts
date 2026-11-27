import { join } from "path";
import { loadExamples } from "../examples";
import { LANGS_DIR } from "../langs";
import type { Session } from "../session";
import { dayDir, stars } from "../store";
import { result } from "../ui";

/** Everything an editor needs to open the day. */
export function info(s: Session) {
  const base = dayDir(s.t.year, s.t.day);
  const firstFile = loadExamples(s.t.year, s.t.day).find((e) => e.input)?.input;
  return {
    year: s.t.year,
    day: s.t.day,
    title: s.state.title,
    part: s.part,
    stars: stars(s.state),
    lang: s.lang.id,
    langName: s.lang.name,
    langReason: s.state.langReason,
    dir: s.dir,
    solution: { 1: join(s.dir, s.lang.solution[1]), 2: join(s.dir, s.lang.solution[2]) },
    puzzle: join(base, "puzzle.md"),
    examples: join(base, "examples.toml"),
    /** First example that lives in its own file (inline-text examples only exist in examples.toml). */
    exampleFile: firstFile ? join(base, firstFile) : undefined,
    input: join(base, "input.txt"),
    /** The language's untouched template for each part, so editors can tell "not started" from "in progress". */
    template: { 1: join(LANGS_DIR, s.lang.id, "template", s.lang.solution[1]), 2: join(LANGS_DIR, s.lang.id, "template", s.lang.solution[2]) },
    answers: { 1: s.state.parts[1].answer, 2: s.state.parts[2].answer },
  };
}

export function infoCommand(s: Session) {
  const i = info(s);
  result(i, `${i.year} day ${i.day}${i.title ? `: ${i.title}` : ""} · part ${i.part} · ${i.langName}\n${i.solution[i.part]}`);
}
