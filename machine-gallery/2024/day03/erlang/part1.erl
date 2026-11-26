%% Mull It Over: re:run with `global` returns the capture groups of every match;
%% a list comprehension multiplies and sums them.
-module(part1).
-export([solve/1]).

solve(Input) ->
    {match, Pairs} = re:run(Input, <<"mul\\((\\d{1,3}),(\\d{1,3})\\)">>, [global, {capture, all_but_first, binary}]),
    lists:sum([binary_to_integer(A) * binary_to_integer(B) || [A, B] <- Pairs]).
