%% Report Repair: function clauses walk the list; for each head, look for its
%% complement in the tail. O(n^2) is plenty for 200 entries.
-module(part1).
-export([solve/1, parse/1, pair_product/2]).

parse(Input) -> [binary_to_integer(L) || L <- aoc:lines(Input)].

pair_product([], _Target) -> undefined;
pair_product([X | Rest], Target) ->
    case lists:member(Target - X, Rest) of
        true -> X * (Target - X);
        false -> pair_product(Rest, Target)
    end.

solve(Input) -> pair_product(parse(Input), 2020).
