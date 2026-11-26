import { writeFileSync } from "fs";
import { join } from "path";
import * as api from "./api";
import { exampleInput, loadExamples, saveExamples, writeExampleFile, type Example } from "./examples";
import { acceptedAnswers, extractExamples, title, toMarkdown } from "./puzzle";
import { dayDir, loadDay, saveDay, type Target } from "./store";
import { c, say, warn } from "./ui";

/** Merge freshly extracted examples into examples.toml without clobbering your edits. Matches by input text. */
export function mergeExamples(
  existing: Example[],
  found: ReturnType<typeof extractExamples>,
  io: { read: (e: Example) => string; write: (n: number, text: string) => string },
): { examples: Example[]; added: number } {
  const examples = existing.map((e) => ({ ...e }));
  const texts = examples.map((e) => io.read(e));
  let added = 0;
  for (const f of found) {
    const i = texts.indexOf(f.text);
    if (i >= 0) {
      if (f.part1 && !examples[i].part1) examples[i].part1 = f.part1;
      if (f.part2 && !examples[i].part2) examples[i].part2 = f.part2;
      continue;
    }
    const inline = !f.text.includes("\n") && f.text.length < 80;
    const n = examples.length + 1;
    examples.push({ ...(inline ? { text: f.text } : { input: io.write(n, f.text) }), part1: f.part1 ?? "", part2: f.part2 ?? "", auto: true });
    texts.push(f.text);
    added++;
  }
  return { examples, added };
}

/**
 * Fetch (or reuse cached) puzzle page, write puzzle.md, merge examples, import accepted answers.
 * `refresh` re-downloads the page, e.g. right after part 1 is accepted.
 */
export async function syncPuzzle(t: Target, refresh = false): Promise<void> {
  const html = await api.puzzleHtml(t.year, t.day, refresh);
  const dir = dayDir(t.year, t.day);
  writeFileSync(join(dir, "puzzle.md"), toMarkdown(html, t.year, t.day));

  const state = loadDay(t.year, t.day);
  state.title ??= title(html);
  acceptedAnswers(html).forEach((answer, i) => {
    const p = state.parts[(i + 1) as 1 | 2];
    if (p.answer === undefined) {
      p.answer = answer;
      p.solvedAt ??= new Date().toISOString();
    }
  });
  saveDay(state);

  const found = extractExamples(html);
  const { examples, added } = mergeExamples(loadExamples(t.year, t.day), found, {
    read: (e) => exampleInput(t.year, t.day, e),
    write: (n, text) => writeExampleFile(t.year, t.day, n, text),
  });
  saveExamples(t.year, t.day, examples);
  if (added) say(c.dim(`✦ ${added} example(s) → examples.toml`));
  if (found.some((f) => !f.confident)) warn("some examples were extracted with low confidence. Check examples.toml before trusting `aoc test`.");
  if (found.some((f) => f.constantsDiffer)) warn('the example uses different constants than the real input. Add `args = { size = 7 }` to the example in examples.toml and read it with arg("size", 71).');
}
