%% One regex for all three instructions; a fold with one clause per instruction
%% shape toggles the enabled flag.
-module(part2).
-export([solve/1]).

solve(Input) ->
    Re = <<"mul\\((\\d{1,3}),(\\d{1,3})\\)|do\\(\\)|don't\\(\\)">>,
    {match, Matches} = re:run(Input, Re, [global, {capture, all, binary}]),
    {_, Sum} = lists:foldl(fun step/2, {true, 0}, Matches),
    Sum.

step([<<"do()">> | _], {_, Sum}) -> {true, Sum};
step([<<"don't()">> | _], {_, Sum}) -> {false, Sum};
step([_, A, B], {true, Sum}) -> {true, Sum + binary_to_integer(A) * binary_to_integer(B)};
step(_, Acc) -> Acc.
