%% Fix the head X, reuse part 1's pair search on the tail for 2020 - X.
-module(part2).
-export([solve/1]).

triple_product([], _Target) -> undefined;
triple_product([X | Rest], Target) ->
    case part1:pair_product(Rest, Target - X) of
        undefined -> triple_product(Rest, Target);
        P -> X * P
    end.

solve(Input) -> triple_product(part1:parse(Input), 2020).
