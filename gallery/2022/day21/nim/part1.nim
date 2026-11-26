## Day 21: Monkey Math — each monkey's job is an object variant (number or
## binary op) in a `Table`; evaluation is plain recursion with `case`.
## `strscans.scanf` splits both line shapes without regexes.
import std/[strutils, strscans, tables]

type
  JobKind* = enum jkNumber, jkOp
  Job* = object
    case kind*: JobKind
    of jkNumber: value*: int
    of jkOp:
      op*: char
      lhs*, rhs*: string
  Troop* = Table[string, Job]

func parseTroop*(input: string): Troop =
  for line in input.strip.splitLines:
    var name, lhs, rhs: string
    var op: char
    var value: int
    if line.scanf("$w: $w $c $w", name, lhs, op, rhs):
      result[name] = Job(kind: jkOp, op: op, lhs: lhs, rhs: rhs)
    elif line.scanf("$w: $i", name, value):
      result[name] = Job(kind: jkNumber, value: value)

func apply(op: char, a, b: int): int =
  case op
  of '+': a + b
  of '-': a - b
  of '*': a * b
  of '/': a div b
  else: raise newException(ValueError, "unknown op " & op)

func eval*(troop: Troop, name: string): int =
  let job = troop[name]
  case job.kind
  of jkNumber: job.value
  of jkOp: apply(job.op, troop.eval(job.lhs), troop.eval(job.rhs))

proc solve*(input: string): int =
  parseTroop(input).eval("root")
