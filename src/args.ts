import { resolve } from "path";
import type { Part } from "./store";

export const COMMANDS = [
  "start", "info", "test", "run", "submit", "verify", "watch", "puzzle", "lang", "langs", "status", "ex", "where", "help",
] as const;
export type Command = (typeof COMMANDS)[number];

export interface Args {
  command: Command;
  /** Positional target tokens (years, days, "next"). */
  target: string[];
  /** Positional words after the command that aren't targets (e.g. `lang rust`, `ex add`). */
  rest: string[];
  part?: Part;
  lang?: string;
  /** `aoc run --input big.txt`: any file instead of input.txt (no answer comparison). */
  input?: string;
  json: boolean;
  /** `aoc gallery …`: operate on machine-gallery/ instead of solutions/. */
  gallery: boolean;
  yes: boolean;
  force: boolean;
}

export class ArgError extends Error {}

const VALUE_FLAGS = new Set(["--lang", "--part", "-p", "--year", "--day", "--input", "-i"]);

export function parseArgs(argv: string[]): Args {
  const a: Args = { command: "start", target: [], rest: [], json: false, gallery: false, yes: false, force: false };
  const words: string[] = [];
  let year: string | undefined;
  let day: string | undefined;

  for (let i = 0; i < argv.length; i++) {
    let arg = argv[i];
    let value: string | undefined;
    const eq = arg.match(/^(--[a-z-]+)=(.*)$/);
    if (eq) [arg, value] = [eq[1], eq[2]];
    if (VALUE_FLAGS.has(arg) && value === undefined) {
      value = argv[++i];
      if (value === undefined) throw new ArgError(`${arg} needs a value`);
    }
    switch (arg) {
      case "--lang": a.lang = value; break;
      case "--input": case "-i": a.input = resolve(value!); break;
      case "--part": case "-p": a.part = part(value!); break;
      case "--year": year = value; break;
      case "--day": day = value; break;
      case "--json": a.json = true; break;
      case "--yes": case "-y": a.yes = true; break;
      case "--force": case "-f": a.force = true; break;
      case "-h": case "--help": a.command = "help"; break;
      default:
        if (arg.startsWith("-")) throw new ArgError(`Unknown flag ${arg}`);
        words.push(arg);
    }
  }

  if (words[0] === "gallery") {
    a.gallery = true;
    words.shift();
  }
  if (words.length && (COMMANDS as readonly string[]).includes(words[0])) a.command = words.shift() as Command;
  for (const w of words) {
    if (a.command === "ex" && a.rest.length) a.rest.push(w); // `aoc ex add p1 142`: numbers after "add" are answers
    else if (/^p[12]$/.test(w)) a.part = part(w.slice(1));
    else if (w === "next" || /^\d{1,4}(\/\d{1,2})?$/.test(w)) a.target.push(w);
    else a.rest.push(w);
  }
  if (a.rest.length && !["lang", "langs", "ex"].includes(a.command)) throw new ArgError(`Don't understand "${a.rest.join(" ")}". See aoc help`);
  if (year) a.target.unshift(year);
  if (day) a.target.push(day);
  return a;
}

function part(v: string): Part {
  if (v !== "1" && v !== "2") throw new ArgError(`Part must be 1 or 2, got ${v}`);
  return Number(v) as Part;
}
