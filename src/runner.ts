import { createHash } from "crypto";
import { readdirSync, readFileSync, statSync } from "fs";
import { join, relative } from "path";
import { LANGS_DIR, type Lang } from "./langs";
import { ROOT, type Part } from "./store";
import { c, say } from "./ui";

export interface RunEnv {
  part: Part;
  args?: Record<string, unknown>;
  example: boolean;
}

export interface RunResult {
  ok: boolean;
  answer?: string;
  /** stdout minus the answer line, plus stderr. */
  log: string;
  code: number;
  ms: number;
}

export class BuildError extends Error {
  name = "AocError";
  constructor(public lang: string, public log: string) {
    super(`${lang} build failed:\n${log.trimEnd()}`);
  }
}

async function sh(cmd: string[], opts: { stdin?: string; cwd?: string; env?: Record<string, string>; stream?: boolean } = {}) {
  const proc = Bun.spawn(cmd, {
    cwd: opts.cwd,
    env: { ...process.env, ...opts.env },
    stdin: opts.stdin !== undefined ? Buffer.from(opts.stdin) : "ignore",
    stdout: "pipe",
    stderr: opts.stream ? "inherit" : "pipe",
  });
  const [stdout, stderr] = await Promise.all([new Response(proc.stdout).text(), opts.stream ? "" : new Response(proc.stderr!).text()]);
  return { code: await proc.exited, stdout, stderr };
}

// --- docker -----------------------------------------------------------------

function langHash(lang: Lang): string {
  const h = createHash("sha256");
  const dir = join(LANGS_DIR, lang.id);
  const walk = (d: string) => {
    for (const name of readdirSync(d).sort()) {
      const p = join(d, name);
      if (name === "template" && d === dir) continue;
      if (statSync(p).isDirectory()) walk(p);
      else h.update(relative(dir, p)).update(readFileSync(p));
    }
  };
  walk(dir);
  return h.update("mount:root").digest("hex").slice(0, 10);
}

const containerName = (lang: Lang) => `aoc-${lang.id}`;

async function ensureContainer(lang: Lang): Promise<string> {
  const name = containerName(lang);
  const hash = langHash(lang);
  const image = `aoc-${lang.id}:${hash}`;
  const inspect = await sh(["docker", "inspect", "-f", '{{index .Config.Labels "aoc.hash"}} {{.State.Running}}', name]);
  const [have, running] = inspect.stdout.trim().split(" ");
  if (inspect.code === 0 && have === hash && running === "true") return name;

  if (inspect.code === 0) await sh(["docker", "rm", "-f", name]);
  const img = await sh(["docker", "image", "inspect", image]);
  if (img.code !== 0) {
    say(c.dim(`🐳 building ${image} (first use of ${lang.name}, this can take a few minutes)…`));
    const built = await sh(["docker", "build", "--progress=plain", "-t", image, "-t", `aoc-${lang.id}:latest`, join(LANGS_DIR, lang.id)]);
    if (built.code !== 0) throw new BuildError(lang.id, `docker build failed:\n${(built.stdout + built.stderr).split("\n").slice(-40).join("\n")}`);
  }
  const volumes = Object.entries(lang.caches ?? {}).flatMap(([path, vol]) => ["-v", `aoc-cache-${vol}:${path}`]);
  const run = await sh([
    "docker", "run", "-d", "--name", name, "--label", `aoc.hash=${hash}`, "--init",
    "-v", `${ROOT}:/aoc`, ...volumes, image, "sleep", "infinity",
  ]);
  if (run.code !== 0) throw new BuildError(lang.id, run.stderr);
  return name;
}

function containerCwd(dir: string): string {
  return "/aoc/" + relative(ROOT, dir);
}

// --- public -----------------------------------------------------------------

export interface Runner {
  build(): Promise<void>;
  run(input: string, env: RunEnv): Promise<RunResult>;
}

export async function runner(lang: Lang, dir: string): Promise<Runner> {
  const container = await ensureContainer(lang);

  const exec = (cmd: string, opts: { stdin?: string; env?: Record<string, string> } = {}) => {
    const envFlags = Object.entries(opts.env ?? {}).flatMap(([k, v]) => ["-e", `${k}=${v}`]);
    return sh(["docker", "exec", ...(opts.stdin !== undefined ? ["-i"] : []), "-w", containerCwd(dir), ...envFlags, container, "sh", "-c", cmd], opts);
  };

  // Ctrl-C doesn't reach processes inside `docker exec`; kill the warm container instead.
  const onInt = () => {
    Bun.spawnSync(["docker", "rm", "-f", container]);
    process.exit(130);
  };

  return {
    async build() {
      if (!lang.build) return;
      const r = await exec(lang.build);
      if (r.code !== 0) throw new BuildError(lang.id, r.stdout + r.stderr);
    },
    async run(input, env) {
      process.on("SIGINT", onInt);
      const t0 = performance.now();
      const r = await exec(lang.run, {
        stdin: input,
        env: { AOC_PART: String(env.part), AOC_ARGS: JSON.stringify(env.args ?? {}), AOC_EXAMPLE: env.example ? "1" : "0" },
      });
      const ms = performance.now() - t0;
      process.off("SIGINT", onInt);
      const lines = r.stdout.trimEnd().split("\n");
      const answer = lines.pop()?.trim() || undefined;
      return { ok: r.code === 0 && answer !== undefined, answer: r.code === 0 ? answer : undefined, log: (r.code === 0 ? lines.join("\n") : r.stdout) + r.stderr, code: r.code, ms };
    },
  };
}

export async function pruneContainers(): Promise<string[]> {
  const ps = await sh(["docker", "ps", "-a", "--filter", "name=^aoc-", "--format", "{{.Names}}"]);
  const names = ps.stdout.split("\n").filter(Boolean);
  if (names.length) await sh(["docker", "rm", "-f", ...names]);
  return names;
}
