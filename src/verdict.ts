import { decode } from "./puzzle";
import type { Part, PartState, Submission, Verdict } from "./store";

export interface ParsedVerdict {
  verdict: Verdict;
  /** Seconds AoC wants you to wait before the next attempt. */
  waitSeconds?: number;
  message: string;
}

function duration(text: string): number | undefined {
  const m = text.match(/(?:(\d+)m\s*)?(\d+)s left to wait/) ?? text.match(/wait (one|\d+) minutes?/);
  if (!m) return undefined;
  if (m[0].includes("left")) return Number(m[1] ?? 0) * 60 + Number(m[2]);
  return (m[1] === "one" ? 1 : Number(m[1])) * 60;
}

export function parseVerdict(html: string): ParsedVerdict {
  const article = html.match(/<article>([\s\S]*?)<\/article>/)?.[1] ?? html;
  const message = decode(article).replace(/\s+/g, " ").trim();
  const waitSeconds = duration(message);
  if (/That's the right answer/.test(message)) return { verdict: "correct", message };
  if (/You gave an answer too recently/.test(message)) return { verdict: "wait", waitSeconds, message };
  if (/Did you already complete it/.test(message)) return { verdict: "done", message };
  if (/That's not the right answer/.test(message)) {
    const verdict = /too high/.test(message) ? "high" : /too low/.test(message) ? "low" : "wrong";
    return { verdict, waitSeconds, message };
  }
  return { verdict: "unknown", message };
}

/** Numeric bounds learnt from "too high/low" replies. */
export function bounds(p: PartState): { low?: bigint; high?: bigint } {
  let low: bigint | undefined;
  let high: bigint | undefined;
  for (const s of p.submissions) {
    if (!/^-?\d+$/.test(s.answer)) continue;
    const n = BigInt(s.answer);
    if (s.verdict === "low" && (low === undefined || n > low)) low = n;
    if (s.verdict === "high" && (high === undefined || n < high)) high = n;
  }
  return { low, high };
}

/** Why an answer shouldn't be sent, or null when it's worth a try. */
export function refuse(p: PartState, answer: string, now: number, part: Part): string | null {
  if (p.answer !== undefined) return p.answer === answer ? `part ${part} already accepted with this answer` : `part ${part} already accepted as ${p.answer}; you got ${answer}`;
  const prior = p.submissions.find((s: Submission) => s.answer === answer && s.verdict !== "wait" && s.verdict !== "unknown");
  if (prior) return `already tried ${answer}: ${prior.verdict} (${prior.at})`;
  if (!answer.trim() || answer === "0") return `answer is "${answer}", which looks like an unfinished template`;
  if (/^-?\d+$/.test(answer)) {
    const n = BigInt(answer);
    const { low, high } = bounds(p);
    if (low !== undefined && n <= low) return `${answer} ≤ ${low}, which was too low`;
    if (high !== undefined && n >= high) return `${answer} ≥ ${high}, which was too high`;
  }
  const last = p.submissions.at(-1);
  if (last?.waitUntil && Date.parse(last.waitUntil) > now) return `AoC cooldown: wait ${Math.ceil((Date.parse(last.waitUntil) - now) / 1000)}s`;
  return null;
}
