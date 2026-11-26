## Day 15, part 2 — the full map is the input tiled 5×5; `Cave.risk`
## derives tile values on the fly, so nothing is materialised.
import part1

proc solve*(input: string): int =
  parseCave(input, tiles = 5).lowestTotalRisk
