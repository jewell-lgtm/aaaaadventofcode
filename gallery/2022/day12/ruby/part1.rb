# Hill Climbing Algorithm, part 1: layered BFS from S to E.
# Ruby: flat_map builds each frontier; Set#add? doubles as the "not seen yet" test.
require "aoc"
require "hill"

def solve(input) = Hill.shortest_path(input, %w[S])
