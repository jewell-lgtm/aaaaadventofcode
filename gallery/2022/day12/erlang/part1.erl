%% Hill Climbing: level-by-level BFS; each new frontier is a list comprehension whose
%% filters are the step rule. CanStep and Goal are funs so part 2 can run backwards.
-module(part1).
-export([solve/1, parse/1, find/2, height/2, bfs/4]).

parse(Input) ->
    maps:from_list([{{R, C}, Ch} || {R, Row} <- enumerate(aoc:lines(Input)),
                                    {C, Ch} <- enumerate(binary_to_list(Row))]).

enumerate(L) -> lists:zip(lists:seq(0, length(L) - 1), L).

find(Grid, Ch) -> hd([Pos || {Pos, X} <- maps:to_list(Grid), X =:= Ch]).

height(Grid, Pos) ->
    case maps:get(Pos, Grid) of
        $S -> $a;
        $E -> $z;
        Ch -> Ch
    end.

bfs(Grid, Start, CanStep, Goal) -> bfs(Grid, [Start], #{Start => true}, 0, CanStep, Goal).

bfs(_Grid, [], _Seen, _Steps, _CanStep, _Goal) -> unreachable;
bfs(Grid, Frontier, Seen, Steps, CanStep, Goal) ->
    case lists:any(Goal, Frontier) of
        true -> Steps;
        false ->
            Next = lists:usort([Q || {R, C} = P <- Frontier,
                                     Q <- [{R - 1, C}, {R + 1, C}, {R, C - 1}, {R, C + 1}],
                                     maps:is_key(Q, Grid),
                                     not maps:is_key(Q, Seen),
                                     CanStep(height(Grid, P), height(Grid, Q))]),
            bfs(Grid, Next, maps:merge(Seen, maps:from_keys(Next, true)), Steps + 1, CanStep, Goal)
    end.

solve(Input) ->
    Grid = parse(Input),
    End = find(Grid, $E),
    bfs(Grid, find(Grid, $S), fun(From, To) -> To =< From + 1 end, fun(P) -> P =:= End end).
