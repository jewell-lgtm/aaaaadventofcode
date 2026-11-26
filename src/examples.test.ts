import { expect, test } from "bun:test";
import { serializeExamples, type Example } from "./examples";

test("examples.toml round-trips", () => {
  const examples: Example[] = [
    { input: "examples/1.txt", part1: "142", part2: "", auto: true },
    { text: 'a\\b """ c\n', part1: "", part2: "281", args: { size: 7, name: "x y" } },
  ];
  const parsed = Bun.TOML.parse(serializeExamples(examples)) as { example: Example[] };
  expect(parsed.example).toEqual(examples);
});
