%% The CrateMover 9001 moves crates as a block, keeping their order.
-module(part2).
-export([solve/1]).

solve(Input) -> part1:run(Input, fun(Crates) -> Crates end).
