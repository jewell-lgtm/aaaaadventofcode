%% Hot Springs: recursive count over the remaining (springs, groups) with binary
%% pattern matching, e.g. <<Run:G/binary, Rest/binary>> slices off a whole group.
%% The memo is an ordinary map threaded through every call.
-module(part1).
-export([solve/1, arrangements/2, parse_line/1]).

arrangements(Springs, Groups) ->
    {N, _Memo} = count(Springs, Groups, #{}),
    N.

%% Both arguments are suffixes of the originals, so their lengths identify the subproblem.
count(Springs, Groups, Memo) ->
    Key = {byte_size(Springs), length(Groups)},
    case Memo of
        #{Key := N} -> {N, Memo};
        _ ->
            {N, Memo1} = step(Springs, Groups, Memo),
            {N, Memo1#{Key => N}}
    end.

step(<<>>, [], Memo) -> {1, Memo};
step(<<>>, _, Memo) -> {0, Memo};
step(<<$., Rest/binary>>, Groups, Memo) -> count(Rest, Groups, Memo);
step(<<$#, _/binary>> = S, Groups, Memo) -> damaged(S, Groups, Memo);
step(<<$?, Rest/binary>> = S, Groups, Memo) ->
    {A, Memo1} = count(Rest, Groups, Memo),
    {B, Memo2} = damaged(S, Groups, Memo1),
    {A + B, Memo2}.

%% Place the next group at the start of S: G springs with no '.', then end or a non-'#'.
damaged(S, [G | Groups], Memo) ->
    case S of
        <<Run:G/binary, After/binary>> ->
            case {binary:match(Run, <<".">>), After} of
                {nomatch, <<>>} -> count(<<>>, Groups, Memo);
                {nomatch, <<Sep, Rest/binary>>} when Sep =/= $# -> count(Rest, Groups, Memo);
                _ -> {0, Memo}
            end;
        _ -> {0, Memo}
    end;
damaged(_S, [], Memo) -> {0, Memo}.

parse_line(Line) ->
    [Springs, Groups] = binary:split(Line, <<" ">>),
    {Springs, [binary_to_integer(G) || G <- binary:split(Groups, <<",">>, [global])]}.

solve(Input) ->
    lists:sum([arrangements(S, G) || {S, G} <- [parse_line(L) || L <- aoc:lines(Input)]]).
