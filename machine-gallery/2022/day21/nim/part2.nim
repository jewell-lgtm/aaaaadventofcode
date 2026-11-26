## Day 21, part 2 — root becomes `lhs == rhs`. Walk down the one branch that
## contains "humn", evaluating the other side and inverting each op to push
## the required value toward the leaf. No search, just algebra.
import std/tables
import part1

func dependsOnHuman(troop: Troop, name: string): bool =
  if name == "humn": return true
  let job = troop[name]
  job.kind == jkOp and (troop.dependsOnHuman(job.lhs) or troop.dependsOnHuman(job.rhs))

func invert(op: char, target, known: int, humanOnLeft: bool): int =
  ## Solve `x op known = target` (or `known op x = target`) for x.
  case op
  of '+': target - known
  of '*': target div known
  of '-': (if humanOnLeft: target + known else: known - target)
  of '/': (if humanOnLeft: target * known else: known div target)
  else: raise newException(ValueError, "unknown op " & op)

func humanValue(troop: Troop): int =
  let root = troop["root"]
  var (name, target) =
    if troop.dependsOnHuman(root.lhs): (root.lhs, troop.eval(root.rhs))
    else: (root.rhs, troop.eval(root.lhs))
  while name != "humn":
    let job = troop[name]
    let humanOnLeft = troop.dependsOnHuman(job.lhs)
    let (next, other) = if humanOnLeft: (job.lhs, job.rhs) else: (job.rhs, job.lhs)
    target = invert(job.op, target, troop.eval(other), humanOnLeft)
    name = next
  target

proc solve*(input: string): int =
  parseTroop(input).humanValue
