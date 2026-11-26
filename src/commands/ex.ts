import type { Args } from "../args";
import { exampleInput, loadExamples, saveExamples, writeExampleFile } from "../examples";
import type { Target } from "../store";
import { c, result } from "../ui";

/**
 * aoc ex                       list examples
 * aoc ex add [p1|p2] <answer>  add stdin as a new example (pbpaste | aoc ex add p2 281)
 */
export async function exCommand(t: Target, args: Args) {
  const [sub, ...rest] = args.rest;
  const examples = loadExamples(t.year, t.day);
  if (sub === "add") {
    const answer = rest.find((r) => !/^p[12]$/.test(r));
    const part = rest.includes("p2") || args.part === 2 ? 2 : 1;
    if (!answer) throw Object.assign(new Error("usage: aoc ex add [p1|p2] <expected> < input"), { name: "AocError" });
    const text = await Bun.stdin.text();
    if (!text.trim()) throw Object.assign(new Error("example input comes from stdin, e.g. pbpaste | aoc ex add p1 42"), { name: "AocError" });
    const n = examples.length + 1;
    examples.push({ input: writeExampleFile(t.year, t.day, n, text), [`part${part}`]: answer, auto: false });
    saveExamples(t.year, t.day, examples);
    return result({ ...t, added: n }, c.green(`✦ example ${n}: part ${part} → ${answer}`));
  }
  result(
    { ...t, examples },
    examples
      .map((e, i) => {
        const preview = exampleInput(t.year, t.day, e).trimEnd().split("\n");
        const head = preview.slice(0, 3).join(c.dim("⏎")) + (preview.length > 3 ? c.dim(` …+${preview.length - 3} lines`) : "");
        return `${c.bold(`#${i + 1}`)} p1=${e.part1 || "-"} p2=${e.part2 || "-"}${e.args ? ` args=${JSON.stringify(e.args)}` : ""}${e.auto ? c.dim(" auto") : ""}\n   ${head}`;
      })
      .join("\n") || "no examples. Add one: pbpaste | aoc ex add p1 <expected>",
  );
}
