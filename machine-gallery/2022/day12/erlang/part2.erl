%% Backwards from E with the step rule reversed, until any square of height 'a'.
-module(part2).
-export([solve/1]).

solve(Input) ->
    Grid = part1:parse(Input),
    part1:bfs(Grid, part1:find(Grid, $E),
              fun(From, To) -> From =< To + 1 end,
              fun(P) -> part1:height(Grid, P) =:= $a end).
