import { expect, test } from "bun:test";
import { candidates, questions } from "./jev";
import { emptyDay, type DayState } from "./store";

const day = (d: number, lang?: string): DayState => ({ ...emptyDay(2026, d), lang });

test("recent languages are off the table; used-this-year is reported", () => {
  const history = [day(1, "ts"), day(2, "rust"), day(3, "python"), day(4, "go"), day(6, "zig")];
  const c = candidates(day(5), history);
  expect(c.recent).toEqual(["go", "python", "rust"]);
  expect(c.usedThisYear.sort()).toEqual(["go", "python", "rust", "ts", "zig"]);
  const ids = c.choices.map((l) => l.id);
  expect(ids).toContain("ts");
  expect(ids).not.toContain("go");
  expect(ids).not.toContain("rust");
});

test("repick excludes the current language", () => {
  const ids = candidates(day(1), [], ["ts"]).choices.map((l) => l.id);
  expect(ids).not.toContain("ts");
  expect(ids).toContain("python");
});

test("question criteria mark specialists", () => {
  const q = questions({ choices: [{ id: "octave", name: "Octave", criteria: "tables", specialist: true, solution: { 1: "a", 2: "b" }, run: "x" }], recent: [], usedThisYear: [] });
  expect(q.language.criteria.octave).toStartWith("SPECIALIST.");
});
