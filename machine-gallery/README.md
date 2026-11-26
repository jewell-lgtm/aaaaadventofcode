# 🤖 machine-gallery: written by agents, not by Matt

Everything below this folder was written by AI agents as reference material: 10 classic AoC puzzles solved in each of the 32 bank languages, for browsing when you're choosing a language for a kind of problem.

It's kept apart from `solutions/` on purpose:

- None of it counts toward your stars, `aoc status`, `aoc next`, `aoc verify` or JEV's language history.
- The CLI only touches it under `aoc gallery …`, and prints a 🤖 banner when it does.
- nvim opens these files read-only, with a 🤖 winbar.
- Commits that change it start with `machine:`.

| dir | puzzle | archetype |
|---|---|---|
| 2024/day03 | Mull It Over | regex |
| 2020/day01 | Report Repair | sets |
| 2022/day05 | Supply Stacks | messy parsing |
| 2022/day12 | Hill Climbing Algorithm | BFS |
| 2021/day15 | Chiton | Dijkstra |
| 2023/day07 | Camel Cards | custom sort |
| 2022/day11 | Monkey in the Middle | records + modular maths |
| 2023/day12 | Hot Springs | memoised DP |
| 2022/day21 | Monkey Math | expression trees |
| 2021/day14 | Extended Polymerization | counting |

Puzzle text and inputs are gitignored. `aoc gallery start <year> <day>` fetches them.
