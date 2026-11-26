import { describe, expect, test } from "bun:test";
import { emptyDay, type DayState } from "./store";
import { parseTargetTokens, resolveTarget, TargetError, type TargetContext } from "./target";

const at = (iso: string) => Date.parse(iso);

function ctx(now: string, days: Partial<DayState>[] = [], extra: Partial<TargetContext> = {}): TargetContext {
  return {
    now: at(now),
    cwd: null,
    last: undefined,
    lookup: (year, day) => {
      const found = days.find((d) => d.year === year && d.day === day);
      return { ...emptyDay(year, day), ...found } as DayState;
    },
    ...extra,
  };
}

const started = (year: number, day: number, solved: 0 | 1 | 2 = 0): Partial<DayState> => ({
  year,
  day,
  startedAt: "x",
  parts: {
    1: { submissions: [], answer: solved >= 1 ? "1" : undefined },
    2: { submissions: [], answer: solved >= 2 ? "2" : undefined },
  },
});

const resolve = (args: string, c: TargetContext) => resolveTarget(parseTargetTokens(args.split(" ").filter(Boolean)), c);

describe("parseTargetTokens", () => {
  test("forms", () => {
    expect(parseTargetTokens(["2026"])).toEqual({ year: 2026, next: false });
    expect(parseTargetTokens(["2017", "3"])).toEqual({ year: 2017, day: 3, next: false });
    expect(parseTargetTokens(["2017/3"])).toEqual({ year: 2017, day: 3, next: false });
    expect(parseTargetTokens(["2026", "next"])).toEqual({ year: 2026, next: true });
  });
  test("rejects junk", () => {
    expect(() => parseTargetTokens(["banana"])).toThrow(TargetError);
    expect(() => parseTargetTokens(["2014"])).toThrow(TargetError);
  });
});

describe("resolveTarget", () => {
  test("bare aoc during event = today (EST unlock)", () => {
    expect(resolve("", ctx("2026-12-03T05:00:00Z"))).toEqual({ year: 2026, day: 3 });
    expect(resolve("", ctx("2026-12-03T04:59:00Z"))).toEqual({ year: 2026, day: 2 });
  });
  test("bare aoc: cwd beats today, last is fallback", () => {
    const c = ctx("2026-12-03T06:00:00Z", [], { cwd: { year: 2017, day: 5 } });
    expect(resolve("", c)).toEqual({ year: 2017, day: 5 });
    expect(resolve("", ctx("2026-06-01T00:00:00Z", [], { last: { year: 2019, day: 2 } }))).toEqual({ year: 2019, day: 2 });
    expect(() => resolve("", ctx("2026-06-01T00:00:00Z"))).toThrow(TargetError);
  });
  test("2025+ has 12 days", () => {
    expect(resolve("", ctx("2026-12-13T06:00:00Z", [], { last: { year: 2026, day: 12 } }))).toEqual({ year: 2026, day: 12 });
    expect(() => resolve("2025 13", ctx("2026-01-01T00:00:00Z"))).toThrow(TargetError);
  });
  test("year = earliest incomplete when not live", () => {
    const c = ctx("2026-06-01T00:00:00Z", [started(2017, 1, 2), started(2017, 2, 1)]);
    expect(resolve("2017", c)).toEqual({ year: 2017, day: 2 });
  });
  test("year = today when live", () => {
    expect(resolve("2026", ctx("2026-12-04T12:00:00Z"))).toEqual({ year: 2026, day: 4 });
  });
  test("next = newest released unattempted", () => {
    const c = ctx("2026-12-04T12:00:00Z", [started(2026, 4), started(2026, 3, 2)]);
    expect(resolve("next", c)).toEqual({ year: 2026, day: 2 });
    expect(resolve("2017 next", c)).toEqual({ year: 2017, day: 25 });
  });
  test("next before the event looks at last year", () => {
    expect(resolve("next", ctx("2026-11-26T12:00:00Z"))).toEqual({ year: 2025, day: 12 });
  });
  test("explicit day uses cwd/last year", () => {
    expect(resolve("7", ctx("2026-06-01T00:00:00Z", [], { last: { year: 2017, day: 1 } }))).toEqual({ year: 2017, day: 7 });
  });
  test("future day refused", () => {
    expect(() => resolve("2026 1", ctx("2026-11-26T12:00:00Z"))).toThrow(/unlocked/);
  });
});
