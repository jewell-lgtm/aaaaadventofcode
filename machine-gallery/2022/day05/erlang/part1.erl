%% Supply Stacks: crates are pulled out of each drawing row with a binary pattern
%% (<<_:Pos/binary, C, _/binary>>); moves are folded over a map of stacks (head = top).
%% The crane fun decides whether lifted crates flip (9000) or keep order (9001).
-module(part1).
-export([solve/1, run/2]).

parse_stacks(Drawing) ->
    [Labels | Rows] = lists:reverse(binary:split(Drawing, <<"\n">>, [global])),
    Count = (byte_size(Labels) + 1) div 4,
    TopDown = lists:reverse(Rows),
    maps:from_list([{I, [C || Row <- TopDown, C <- crate_at(Row, I)]} || I <- lists:seq(1, Count)]).

crate_at(Row, I) ->
    Pos = 4 * I - 3,
    case Row of
        <<_:Pos/binary, C, _/binary>> when C =/= $\s -> [C];
        _ -> []
    end.

parse_move(Line) ->
    [<<"move">>, N, <<"from">>, From, <<"to">>, To] = binary:split(Line, <<" ">>, [global]),
    {binary_to_integer(N), binary_to_integer(From), binary_to_integer(To)}.

apply_move(Crane, {N, From, To}, Stacks) ->
    {Lifted, Rest} = lists:split(N, maps:get(From, Stacks)),
    maps:update_with(To, fun(S) -> Crane(Lifted) ++ S end, Stacks#{From := Rest}).

run(Input, Crane) ->
    [Drawing, Moves] = binary:split(Input, <<"\n\n">>),
    Final = lists:foldl(fun(M, S) -> apply_move(Crane, M, S) end, parse_stacks(Drawing),
                        [parse_move(L) || L <- aoc:lines(Moves)]),
    [Top || {_, [Top | _]} <- lists:sort(maps:to_list(Final))].

solve(Input) -> run(Input, fun lists:reverse/1).
