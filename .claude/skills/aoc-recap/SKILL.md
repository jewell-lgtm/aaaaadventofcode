---
name: aoc-recap
description: Recap an Advent of Code day Matt just finished, covering what he did, idioms of that language he could have used, fun alternative approaches, and how other bank languages would tackle it. Use after he solves a day (or a part), or says "recap", "review my solution", "any fun alternatives", "how would X do this".
---

# aoc-recap

Matt solves each day in a language JEV picked, often one he barely knows. The recap is where the learning sticks. Make it feel like a good code review from a friend who knows the language well: specific, warm, a bit playful, never a lecture.

## Gather

1. `aoc info --json` → year, day, lang, solution paths, `puzzle`.
2. Read `puzzle.md` (both parts if solved) and both solution files.
3. `aoc run p1 --json` / `aoc run p2 --json` for timings and to confirm they match the accepted answers.
4. If the puzzle is in `machine-gallery/` (same year/day), skim a few languages there for contrast. Otherwise reason from the bank in `langs/` (`aoc langs`).

## Write the recap

Use these sections, kept tight. Show code where it helps, small snippets only.

**What you did.** Two or three sentences: the approach, and anything nicely done. Be genuinely specific ("using `+=` with the conditional expression sidestepped a precedence trap"), not generic praise.

**Language idioms.** Up to three things a fluent writer of *this* language would do differently, each a before/after snippet with one line on why. Prefer idioms that will come up again in AoC (counting, parsing, enumerate/zip, comprehensions, pattern matching, built-in collections). If his code is already idiomatic, say so and skip this section.

**Fun alternatives.** Two to four different *ways of thinking* about the puzzle, not micro-optimisations: a one-liner, a mathematical shortcut, a different data structure, a functional versus imperative framing, a regex or string-replace trick. Each with a tiny snippet and a sentence on what makes it fun or when it would win. Label honestly when an alternative is cute but worse.

**In other languages.** Pick two or three bank languages where this puzzle would look interestingly different (e.g. a fold in Haskell or Elixir, `scan` in jq-ish languages, vectorised in Octave or Julia, pattern matching in OCaml). Two to five lines each. Mention if the gallery has a full version.

**Takeaway.** One sentence: the single thing worth remembering for future days.

## Rules

- Don't rewrite his solution files. Snippets go in the reply only. If he wants one applied, he'll say so.
- Performance talk only if it matters. Most early days run in milliseconds; say so and move on.
- Assume he's in nvim; no shell instructions unless asked.
- Never run `aoc submit`.
