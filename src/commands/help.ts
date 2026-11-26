import { result } from "../ui";

const TEXT = `aoc: polyglot Advent of Code harness

TARGETS (any command)
  aoc                  cwd day dir › today (during event) › last day
  aoc 2026             today if live, else earliest incomplete 2026 day
  aoc next             newest released day you haven't started
  aoc 2026 next        same, within 2026
  aoc 2017 3 | 2017/3  explicit

COMMANDS
  aoc [target]         start (fetch puzzle+input, pick lang, scaffold) then test
  aoc test   [p1|p2]   run examples, compare expected
  aoc run    [p1|p2]   real input, compare accepted answer
  aoc submit [p1|p2]   run + submit, record verdict, fetch part 2
  aoc verify [year]    rerun every solved part against accepted answers
  aoc watch            rerun tests on save
  aoc puzzle           print puzzle markdown
  aoc lang [x|repick]  show / set / re-ask JEV for language
  aoc langs            list language bank
  aoc ex add [p1|p2] [expected]   add example from stdin
  aoc status [year]    stars
  aoc where            print resolved target

FLAGS
  --lang X  (or AOC_LANG=X, or LANG=X if X is a bank lang)
  -p N | p1 | p2   part (default: first unsolved)
  --native         run without docker
  --json           machine output (nvim plugin)
  -y               skip confirmations
`;

export function help() {
  result({ help: TEXT }, TEXT);
}
