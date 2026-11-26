## Day 5, part 2 — the CrateMover 9001 lifts a whole slice at once,
## so order is preserved: append the tail slice, then truncate with setLen.
import part1

proc solve*(input: string): string =
  var (stacks, plan) = parse(input)
  for m in plan:
    let cut = stacks[m.src].len - m.count
    stacks[m.dst].add stacks[m.src][cut .. ^1]
    stacks[m.src].setLen cut
  stacks.tops
