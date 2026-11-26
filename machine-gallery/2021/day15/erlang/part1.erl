%% Chiton: Dijkstra with gb_sets (an ordered set of {Dist, Pos}) as the priority queue
%% and a map of best distances. The cave carries a Risk fun, so part 2 can tile it
%% without building a bigger grid.
-module(part1).
-export([solve/1, parse/1, lowest_risk/1]).

parse(Input) ->
    Rows = aoc:lines(Input),
    Grid = maps:from_list([{{R, C}, Ch - $0} || {R, Row} <- lists:enumerate(0, Rows),
                                               {C, Ch} <- lists:enumerate(0, binary_to_list(Row))]),
    #{rows => length(Rows), cols => byte_size(hd(Rows)), risk => fun(P) -> maps:get(P, Grid) end}.

lowest_risk(#{rows := H, cols := W} = Cave) ->
    dijkstra(gb_sets:singleton({0, {0, 0}}), #{{0, 0} => 0}, {H - 1, W - 1}, Cave).

dijkstra(Queue, Best, Goal, Cave) ->
    case gb_sets:take_smallest(Queue) of
        {{Dist, Goal}, _} -> Dist;
        {{Dist, Pos}, Queue1} ->
            {Queue2, Best1} = lists:foldl(fun(Next, Acc) -> relax(Dist, Next, Acc, Cave) end,
                                          {Queue1, Best}, neighbours(Pos, Cave)),
            dijkstra(Queue2, Best1, Goal, Cave)
    end.

relax(Dist, Next, {Queue, Best}, #{risk := Risk}) ->
    D = Dist + Risk(Next),
    case Best of
        #{Next := Known} when Known =< D -> {Queue, Best};
        _ -> {gb_sets:add({D, Next}, Queue), Best#{Next => D}}
    end.

neighbours({R, C}, #{rows := H, cols := W}) ->
    [{R2, C2} || {R2, C2} <- [{R - 1, C}, {R + 1, C}, {R, C - 1}, {R, C + 1}],
                 R2 >= 0, C2 >= 0, R2 < H, C2 < W].

solve(Input) -> lowest_risk(parse(Input)).
