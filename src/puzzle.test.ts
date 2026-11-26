import { describe, expect, test } from "bun:test";
import { readFileSync } from "fs";
import { join } from "path";
import { acceptedAnswers, extractExamples, title, toMarkdown } from "./puzzle";
import { mergeExamples } from "./sync";

const fixture = (n: string) => readFileSync(join(import.meta.dir, "fixtures", n), "utf8");

describe("block examples", () => {
  const html = fixture("block.html");
  test("title, answers", () => {
    expect(title(html)).toBe("Synthetic Sums");
    expect(acceptedAnswers(html)).toEqual(["4242", "99<1"]);
  });
  test("part 2 answer attaches to the reused example", () => {
    expect(extractExamples(html)).toEqual([{ text: "1 2\n3 4\n", part1: "10", part2: "24", confident: true, constantsDiffer: true }]);
  });
  test("markdown", () => {
    const md = toMarkdown(html, 2099, 9);
    expect(md).toContain("## Day 9: Synthetic Sums");
    expect(md).toContain("```\n1 2\n3 4\n```");
    expect(md).toContain("**`10`**");
    expect(md).toContain("> Part 2 answer: `99<1`");
  });
});

describe("list examples", () => {
  test("multiple inputs share one answer; part 2 adds new examples", () => {
    const ex = extractExamples(fixture("list.html")).map(({ text, part1, part2 }) => ({ text, part1, part2 }));
    expect(ex).toEqual([
      { text: "(())", part1: "0", part2: undefined },
      { text: "()()", part1: "0", part2: undefined },
      { text: ")))", part1: "-3", part2: undefined },
      { text: ")", part1: undefined, part2: "1" },
      { text: "()())", part1: undefined, part2: "5" },
    ]);
  });
});

describe("mergeExamples", () => {
  const io = { read: (e: { text?: string; input?: string }) => e.text ?? `file:${e.input}`, write: (n: number) => `examples/${n}.txt` };
  test("keeps your edits, fills blanks, appends new", () => {
    const existing = [{ text: "abc", part1: "7", part2: "", auto: false }];
    const found = [
      { text: "abc", part1: "1", part2: "2", confident: true, constantsDiffer: false },
      { text: "x\ny", part1: "3", confident: true, constantsDiffer: false },
    ];
    const { examples, added } = mergeExamples(existing, found, io);
    expect(added).toBe(1);
    expect(examples).toEqual([
      { text: "abc", part1: "7", part2: "2", auto: false },
      { input: "examples/2.txt", part1: "3", part2: "", auto: true },
    ]);
  });
});

describe("part 2 reusing the part 1 example", () => {
  test("intermediate-state blocks aren't new examples", () => {
    const ex = extractExamples(fixture("reuse.html")).map(({ text, part1, part2 }) => ({ text, part1, part2 }));
    expect(ex).toEqual([{ text: "[A] [B]\nmove 1 from 1 to 2\n", part1: "XY", part2: "YX" }]);
  });
});
