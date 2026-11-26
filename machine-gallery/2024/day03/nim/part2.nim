## Day 3, part 2 — same instruction stream, now a tiny state machine:
## a `case` over the variant toggles `enabled` and gates the products.
import part1

proc solve*(input: string): int =
  var enabled = true
  for instr in instructions(input):
    case instr.kind
    of ikDo: enabled = true
    of ikDont: enabled = false
    of ikMul:
      if enabled: result += instr.a * instr.b
