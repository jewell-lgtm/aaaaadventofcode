import { existsSync, readFileSync } from "fs";
import { join } from "path";
import { dayDir, type Target } from "../store";
import { syncPuzzle } from "../sync";
import { result } from "../ui";

export async function puzzleCommand(t: Target, refresh: boolean) {
  const file = join(dayDir(t.year, t.day), "puzzle.md");
  if (refresh || !existsSync(file)) await syncPuzzle(t, refresh);
  const md = readFileSync(file, "utf8");
  result({ ...t, file, markdown: md }, md);
}
