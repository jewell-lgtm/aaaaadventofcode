// AoC calendar maths. Puzzles unlock at midnight EST (UTC-5) = 05:00 UTC.

export const FIRST_YEAR = 2015;

export function daysInYear(year: number): number {
  return year >= 2025 ? 12 : 25;
}

export function unlockTime(year: number, day: number): number {
  return Date.UTC(year, 11, day, 5);
}

export function isReleased(year: number, day: number, now: number): boolean {
  return day >= 1 && day <= daysInYear(year) && unlockTime(year, day) <= now;
}

/** Most recent year with at least day 1 released. */
export function latestYear(now: number): number {
  const y = new Date(now).getUTCFullYear();
  return isReleased(y, 1, now) ? y : y - 1;
}

/** The puzzle unlocked "today" (AoC time), if the event is running. */
export function today(now: number): { year: number; day: number } | null {
  const est = new Date(now - 5 * 3600_000);
  const year = est.getUTCFullYear();
  const day = est.getUTCDate();
  if (est.getUTCMonth() !== 11 || day > daysInYear(year)) return null;
  return { year, day };
}

export function years(now: number): number[] {
  const out: number[] = [];
  for (let y = FIRST_YEAR; y <= latestYear(now); y++) out.push(y);
  return out;
}

/** Final day has a single puzzle; its second star is free once all others are earned. */
export function isFinalDay(year: number, day: number): boolean {
  return day === daysInYear(year);
}
