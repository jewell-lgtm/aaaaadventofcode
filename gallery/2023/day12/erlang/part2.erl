%% Unfold each row five times (springs joined by "?"), then the same DP.
-module(part2).
-export([solve/1]).

unfold({Springs, Groups}) ->
    {iolist_to_binary(lists:join($?, lists:duplicate(5, Springs))), lists:append(lists:duplicate(5, Groups))}.

solve(Input) ->
    lists:sum([part1:arrangements(S, G) || {S, G} <- [unfold(part1:parse_line(L)) || L <- aoc:lines(Input)]]).
