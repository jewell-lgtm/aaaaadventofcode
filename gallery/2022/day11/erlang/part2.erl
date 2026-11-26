%% No more relief: reduce worry modulo the product of all (prime) divisors, which
%% keeps every divisibility test intact.
-module(part2).
-export([solve/1]).
-include("monkey.hrl").

solve(Input) ->
    part1:monkey_business(Input, 10000, fun(Monkeys) ->
        Modulus = lists:foldl(fun(#monkey{divisor = D}, P) -> D * P end, 1, Monkeys),
        fun(W) -> W rem Modulus end
    end).
