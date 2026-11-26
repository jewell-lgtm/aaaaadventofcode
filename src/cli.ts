#!/usr/bin/env bun
import { ApiError } from "./api";
import { ArgError, parseArgs, type Args } from "./args";
import { start } from "./commands/start";
import { status } from "./commands/status";
import { help } from "./commands/help";
import { runCommand, testCommand } from "./commands/test";
import { langCommand, langsCommand } from "./commands/lang";
import { session } from "./session";
import { exCommand } from "./commands/ex";
import { puzzleCommand } from "./commands/puzzle";
import { submitCommand } from "./commands/submit";
import { verifyCommand } from "./commands/verify";
import { watchCommand } from "./commands/watch";
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
    case "langs":
      return langsCommand(args);
    case "start": {
      const t = resolve(args, now);
      await start(t, args);
      return testCommand(await session(t, args), { fallbackToReal: true });
    }
    case "test":
      return testCommand(await session(resolve(args, now), args));
    case "run":
      return runCommand(await session(resolve(args, now), args));
    case "lang":
      return langCommand(resolve(args, now), args);
    case "ex":
      return exCommand(resolve(args, now), args);
    case "puzzle":
      return puzzleCommand(resolve(args, now), args.force);
    case "submit":
      return submitCommand(await session(resolve(args, now), args), args);
    case "verify":
      return verifyCommand(args.target[0] ? Number(args.target[0]) : undefined, args.lang);
    case "watch":
      return watchCommand(await session(resolve(args, now), args));
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
