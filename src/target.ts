import { daysInYear, FIRST_YEAR, isReleased, latestYear, today } from "./calendar";
import { isAttempted, isComplete, type DayState, type Target } from "./store";

export interface TargetQuery {
  year?: number;
  day?: number;
  next: boolean;
}

export interface TargetContext {
  now: number;
  cwd: Target | null;
  last: Target | undefined;
  lookup: (year: number, day: number) => DayState;
}

export class TargetError extends Error {}

/** Parses positional tokens: `2026`, `2026 3`, `2026/3`, `next`, `2026 next`. */
export function parseTargetTokens(tokens: string[]): TargetQuery {
  const q: TargetQuery = { next: false };
  for (const t of tokens) {
    const slash = t.match(/^(\d{4})\/(\d{1,2})$/);
    if (t === "next") q.next = true;
    else if (slash) [q.year, q.day] = [Number(slash[1]), Number(slash[2])];
    else if (/^\d{4}$/.test(t)) q.year = Number(t);
    else if (/^\d{1,2}$/.test(t)) q.day = Number(t);
    else throw new TargetError(`Don't understand "${t}"`);
  }
  if (q.year !== undefined && q.year < FIRST_YEAR) throw new TargetError(`AoC started in ${FIRST_YEAR}`);
  if (q.next && q.day !== undefined) throw new TargetError(`"next" and a day don't mix`);
  return q;
}

export function resolveTarget(q: TargetQuery, ctx: TargetContext): Target {
  const { now } = ctx;
  const live = today(now);

  if (q.day !== undefined) {
    const year = q.year ?? ctx.cwd?.year ?? ctx.last?.year ?? live?.year ?? latestYear(now);
    return checked({ year, day: q.day }, now);
  }

  if (q.next) {
    const yrs = q.year !== undefined ? [q.year] : range(latestYear(now), FIRST_YEAR);
    for (const year of yrs) {
      for (const day of range(daysInYear(year), 1)) {
        if (isReleased(year, day, now) && !isAttempted(ctx.lookup(year, day))) return { year, day };
      }
    }
    throw new TargetError(`Nothing unattempted${q.year ? ` in ${q.year}` : ""}. Impressive.`);
  }

  if (q.year !== undefined) {
    if (live?.year === q.year) return live;
    for (const day of range(1, daysInYear(q.year))) {
      if (!isReleased(q.year, day, now)) break;
      if (!isComplete(ctx.lookup(q.year, day))) return { year: q.year, day };
    }
    throw new TargetError(`${q.year} is complete (or not released yet). Try "aoc next".`);
  }

  const found = ctx.cwd ?? live ?? ctx.last;
  if (!found) throw new TargetError(`No puzzle today and no previous one. Try "aoc next" or "aoc 2015 1".`);
  return found;
}

function checked(t: Target, now: number): Target {
  if (t.day < 1 || t.day > daysInYear(t.year)) throw new TargetError(`${t.year} has days 1-${daysInYear(t.year)}`);
  if (!isReleased(t.year, t.day, now)) throw new TargetError(`${t.year} day ${t.day} isn't unlocked yet`);
  return t;
}

function range(from: number, to: number): number[] {
  const step = from <= to ? 1 : -1;
  const out: number[] = [];
  for (let i = from; step > 0 ? i <= to : i >= to; i += step) out.push(i);
  return out;
}
