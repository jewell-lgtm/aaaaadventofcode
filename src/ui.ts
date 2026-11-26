// Human output to stderr-safe stdout, or a single JSON document with --json.

let jsonMode = false;
const events: unknown[] = [];

export function setJson(on: boolean) {
  jsonMode = on;
}

export const isJson = () => jsonMode;

export function say(text: string) {
  if (!jsonMode) console.log(text);
}

export function warn(text: string) {
  if (jsonMode) events.push({ warning: text });
  else console.error(`⚠️  ${text}`);
}

/** Final result of a command. In JSON mode the only thing printed to stdout. */
export function result(data: unknown, human?: string) {
  if (jsonMode) console.log(JSON.stringify({ ...(data as object), warnings: events.length ? events : undefined }));
  else if (human) console.log(human);
}

export const c = {
  green: (s: string) => (jsonMode || !process.stdout.isTTY ? s : `\x1b[32m${s}\x1b[0m`),
  red: (s: string) => (jsonMode || !process.stdout.isTTY ? s : `\x1b[31m${s}\x1b[0m`),
  yellow: (s: string) => (jsonMode || !process.stdout.isTTY ? s : `\x1b[33m${s}\x1b[0m`),
  dim: (s: string) => (jsonMode || !process.stdout.isTTY ? s : `\x1b[2m${s}\x1b[0m`),
  bold: (s: string) => (jsonMode || !process.stdout.isTTY ? s : `\x1b[1m${s}\x1b[0m`),
};
