# Hill Climbing Algorithm, part 2: multi-source BFS from every lowest square.
# Ruby: same search, seeded with every S and a.
require "aoc"
require "hill"

def solve(input) = Hill.shortest_path(input, %w[S a])
