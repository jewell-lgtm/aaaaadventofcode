import { existsSync, mkdirSync, readFileSync, statSync, writeFileSync } from "fs";
import { join } from "path";
import { dayDir, ROOT, type Part } from "./store";
import { warn } from "./ui";

const BASE = "https://adventofcode.com";

/** .env next to the repo, so the CLI works from any cwd (e.g. nvim in a day dir). */
export function env(name: string): string | undefined {
  if (process.env[name]) return process.env[name];
  const file = join(ROOT, ".env");
  if (!existsSync(file)) return undefined;
  for (const line of readFileSync(file, "utf8").split("\n")) {
    const m = line.match(/^\s*([A-Z_]+)\s*=\s*(.*?)\s*$/);
    if (m && m[1] === name) return m[2].replace(/^["']|["']$/g, "");
  }
  return undefined;
}

export class ApiError extends Error {}

function headers(): Record<string, string> {
  const session = env("AOC_SESSION");
  if (!session || session === "your_session_cookie_here") {
    throw new ApiError("AOC_SESSION missing in .env (copy the `session` cookie from adventofcode.com)");
  }
  return {
    Cookie: `session=${session}`,
    // AoC's automation guidelines ask for contact info; the repo URL is enough and keeps email out of requests.
    "User-Agent": env("AOC_USER_AGENT") ?? "github.com/jewell-lgtm/aaaaadventofcode (aoc cli)",
  };
}

async function request(path: string, init: RequestInit = {}): Promise<string> {
  const res = await fetch(BASE + path, { ...init, headers: { ...headers(), ...(init.headers as object) } });
  const body = await res.text();
  if (res.status === 400 || res.status === 500) throw new ApiError(`AoC said ${res.status}. Session cookie probably expired.`);
  if (!res.ok) throw new ApiError(`AoC said ${res.status} for ${path}`);
  return body;
}

export const isLoggedIn = (html: string) => !html.includes("[Log In]");

/** Puzzle page HTML. Cached; `refresh` after solving part 1 to get part 2. */
export async function puzzleHtml(year: number, day: number, refresh = false): Promise<string> {
  const file = join(dayDir(year, day), "puzzle.html");
  if (!refresh && existsSync(file)) {
    const cached = readFileSync(file, "utf8");
    // Logged-out copies (part 1 only) get retried hourly, so part 2 shows up once AOC_SESSION works.
    if (isLoggedIn(cached) || Date.now() - statSync(file).mtimeMs < 3600_000) return cached;
  }
  const html = await request(`/${year}/day/${day}`);
  if (!isLoggedIn(html)) warn("puzzle page came back logged out (part 1 only). Refresh AOC_SESSION in .env.");
  mkdirSync(dayDir(year, day), { recursive: true });
  writeFileSync(file, html);
  return html;
}

/** Puzzle input. Fetched once, ever. */
export async function input(year: number, day: number): Promise<string> {
  const file = join(dayDir(year, day), "input.txt");
  if (existsSync(file)) return readFileSync(file, "utf8");
  const text = await request(`/${year}/day/${day}/input`);
  mkdirSync(dayDir(year, day), { recursive: true });
  writeFileSync(file, text);
  return text;
}

/** POSTs an answer, returns the response <article> HTML. */
export async function submit(year: number, day: number, part: Part, answer: string): Promise<string> {
  return request(`/${year}/day/${day}/answer`, {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({ level: String(part), answer }).toString(),
  });
}
