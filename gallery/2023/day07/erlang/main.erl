%% Harness entry: don't edit. stdin = input, AOC_PART = 1|2, prints the answer last.
-module(main).
-export([main/0]).

main() ->
    ok = io:setopts(standard_io, [binary]),
    Input = read_all([]),
    Solver = case os:getenv("AOC_PART") of "2" -> part2; _ -> part1 end,
    io:format("~ts~n", [aoc:to_string(Solver:solve(Input))]),
    halt(0).

read_all(Acc) ->
    case io:get_chars(standard_io, "", 65536) of
        eof -> iolist_to_binary(lists:reverse(Acc));
        Data -> read_all([Data | Acc])
    end.
