import { describe, expect, test } from "bun:test";
import type { PartState } from "./store";
import { parseVerdict, refuse } from "./verdict";

const page = (body: string) => `<html><main><article><p>${body}</p></article></main></html>`;

describe("parseVerdict", () => {
  test("right", () => {
    expect(parseVerdict(page("That's the right answer! You are <span class=\"day-success\">one gold star</span> closer.")).verdict).toBe("correct");
  });
  test("too high / too low / wrong, with lockout", () => {
    const high = parseVerdict(page("That's not the right answer; your answer is too high. If you're stuck... Please wait one minute before trying again."));
    expect(high).toMatchObject({ verdict: "high", waitSeconds: 60 });
    expect(parseVerdict(page("That's not the right answer; your answer is too low.")).verdict).toBe("low");
    expect(parseVerdict(page("That's not the right answer. Because you have guessed incorrectly 4 times on this puzzle, please wait 5 minutes before trying again.")))
      .toMatchObject({ verdict: "wrong", waitSeconds: 300 });
  });
  test("too recently", () => {
    expect(parseVerdict(page("You gave an answer too recently; you have to wait after submitting an answer before trying again. You have 1m 34s left to wait.")))
      .toMatchObject({ verdict: "wait", waitSeconds: 94 });
  });
  test("already done", () => {
    expect(parseVerdict(page("You don't seem to be solving the right level. Did you already complete it?")).verdict).toBe("done");
  });
});

describe("refuse", () => {
  const state = (subs: PartState["submissions"], answer?: string): PartState => ({ submissions: subs, answer });
  const at = "2026-12-01T05:00:00Z";
  test("bounds and repeats", () => {
    const p = state([
      { answer: "100", verdict: "low", at },
      { answer: "500", verdict: "high", at },
      { answer: "300", verdict: "wrong", at },
    ]);
    expect(refuse(p, "100", 0, 1)).toMatch(/already tried/);
    expect(refuse(p, "50", 0, 1)).toMatch(/too low/);
    expect(refuse(p, "900", 0, 1)).toMatch(/too high/);
    expect(refuse(p, "250", 0, 1)).toBeNull();
  });
  test("template zero and accepted", () => {
    expect(refuse(state([]), "0", 0, 1)).toMatch(/template/);
    expect(refuse(state([], "42"), "42", 0, 2)).toMatch(/already accepted/);
  });
  test("cooldown", () => {
    const p = state([{ answer: "1", verdict: "high", at, waitUntil: "2026-12-01T05:01:00Z" }]);
    expect(refuse(p, "0000", Date.parse("2026-12-01T05:00:30Z"), 1)).toMatch(/wait 30s/);
  });
});
