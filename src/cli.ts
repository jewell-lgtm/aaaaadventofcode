#!/usr/bin/env bun
import { ApiError } from "./api";
import { ArgError, parseArgs, type Args } from "./args";
import { start } from "./commands/start";
import { status } from "./commands/status";
import { help } from "./commands/help";
import { loadDay, loadGlobal, saveGlobal, targetFromPath, type Target } from "./store";
import { parseTargetTokens, resolveTarget, TargetError } from "./target";
import { c, result, setJson } from "./ui";

export function resolve(args: Args, now = Date.now()): Target {
  const target = resolveTarget(parseTargetTokens(args.target), {
    now,
    cwd: targetFromPath(process.cwd()),
    last: loadGlobal().last,
    lookup: loadDay,
  });
  saveGlobal({ ...loadGlobal(), last: target });
  return target;
}

async function main(argv: string[]) {
  const args = parseArgs(argv);
  setJson(args.json);
  const now = Date.now();

  switch (args.command) {
    case "help":
      return help();
    case "status":
      return status(args.target[0] ? Number(args.target[0]) : undefined, now);
    case "where": {
      const t = resolve(args, now);
      return result(t, `${t.year} day ${t.day}`);
    }
    case "start":
      return start(resolve(args, now), args);
    default:
      throw new ArgError(`"${args.command}" isn't built yet`);
  }
}

main(process.argv.slice(2)).catch((e) => {
  const known = e instanceof ArgError || e instanceof TargetError || e instanceof ApiError || e?.name === "AocError";
  const message = known ? e.message : (e?.stack ?? String(e));
  if (process.argv.includes("--json")) console.log(JSON.stringify({ error: message }));
  else console.error(c.red(`✗ ${message}`));
  process.exit(known ? 2 : 1);
});
