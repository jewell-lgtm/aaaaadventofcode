## Day 3: Mull It Over — one PCRE alternation walked with `findBounds`,
## yielding instructions from an iterator as an object variant. Nim's std/re
## fills capture groups into a plain array; parts just fold over the stream.
import std/[re, strutils]

type
  InstrKind* = enum ikMul, ikDo, ikDont
  Instr* = object
    case kind*: InstrKind
    of ikMul: a*, b*: int
    of ikDo, ikDont: discard

let pattern = re"mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\)"

iterator instructions*(memory: string): Instr =
  var caps: array[2, string]
  var start = 0
  while true:
    let (first, last) = memory.findBounds(pattern, caps, start)
    if first < 0: break
    let text = memory[first .. last]
    if text.startsWith("mul"):
      yield Instr(kind: ikMul, a: caps[0].parseInt, b: caps[1].parseInt)
    elif text == "do()":
      yield Instr(kind: ikDo)
    else:
      yield Instr(kind: ikDont)
    start = last + 1

proc solve*(input: string): int =
  for instr in instructions(input):
    if instr.kind == ikMul:
      result += instr.a * instr.b
