%% 40 steps: the pair map stays tiny, so this is as fast as part 1.
-module(part2).
-export([solve/1]).

solve(Input) -> part1:spread(Input, 40).
