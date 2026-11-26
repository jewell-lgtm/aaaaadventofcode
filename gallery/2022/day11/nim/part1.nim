## Day 11: Monkey in the Middle — each monkey is an object whose operation is
## an object variant; `simulate` takes the worry-relief rule as a closure.
## Parsing leans on `strscans.scanf` for the fixed-shape lines.
import std/[strutils, strscans, sequtils, algorithm]

type
  OpKind = enum okAdd, okMul, okSquare
  Operation = object
    case kind: OpKind
    of okAdd, okMul: operand: int
    of okSquare: discard
  Monkey* = object
    items: seq[int]
    op: Operation
    divisor*: int
    ifTrue, ifFalse: int
    inspected: int

func apply(op: Operation, old: int): int =
  case op.kind
  of okAdd: old + op.operand
  of okMul: old * op.operand
  of okSquare: old * old

func parseOperation(line: string): Operation =
  let words = line.splitWhitespace      # ... "old" "*" "19"
  if words[^1] == "old": Operation(kind: okSquare)
  elif words[^2] == "*": Operation(kind: okMul, operand: words[^1].parseInt)
  else: Operation(kind: okAdd, operand: words[^1].parseInt)

proc parseMonkey(spec: string): Monkey =
  let lines = spec.splitLines.mapIt(it.strip)
  result.items = lines[1].split(": ")[1].split(", ").map(parseInt)
  result.op = parseOperation(lines[2])
  doAssert lines[3].scanf("Test: divisible by $i", result.divisor)
  doAssert lines[4].scanf("If true: throw to monkey $i", result.ifTrue)
  doAssert lines[5].scanf("If false: throw to monkey $i", result.ifFalse)

proc parseMonkeys*(input: string): seq[Monkey] =
  input.strip.split("\n\n").map(parseMonkey)

proc simulate*(monkeys: var seq[Monkey], rounds: int, relief: proc(w: int): int) =
  for _ in 1 .. rounds:
    for i in 0 ..< monkeys.len:
      let items = move monkeys[i].items
      monkeys[i].inspected += items.len
      for item in items:
        let worry = relief(monkeys[i].op.apply(item))
        let target = if worry mod monkeys[i].divisor == 0: monkeys[i].ifTrue
                     else: monkeys[i].ifFalse
        monkeys[target].items.add worry

func monkeyBusiness*(monkeys: seq[Monkey]): int =
  let counts = monkeys.mapIt(it.inspected).sorted(Descending)
  counts[0] * counts[1]

proc solve*(input: string): int =
  var monkeys = parseMonkeys(input)
  monkeys.simulate(20, proc(w: int): int = w div 3)
  monkeys.monkeyBusiness
