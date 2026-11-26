%% "humn" is the unknown. Walk down from root along the side that depends on humn,
%% inverting each operation against the other side's constant value.
-module(part2).
-export([solve/1]).

solve(Input) ->
    Jobs = part1:parse(Input),
    {_, A, B} = maps:get(<<"root">>, Jobs),
    case humn(Jobs, A) of
        true -> solve_for(Jobs, A, part1:eval(Jobs, B));
        false -> solve_for(Jobs, B, part1:eval(Jobs, A))
    end.

humn(_Jobs, <<"humn">>) -> true;
humn(Jobs, Name) ->
    case maps:get(Name, Jobs) of
        {_, A, B} -> humn(Jobs, A) orelse humn(Jobs, B);
        _ -> false
    end.

%% The value humn must take for Name to evaluate to Target.
solve_for(_Jobs, <<"humn">>, Target) -> Target;
solve_for(Jobs, Name, Target) ->
    {Op, A, B} = maps:get(Name, Jobs),
    case humn(Jobs, A) of
        true -> solve_for(Jobs, A, invert_left(Op, Target, part1:eval(Jobs, B)));
        false -> solve_for(Jobs, B, invert_right(Op, Target, part1:eval(Jobs, A)))
    end.

%% Target = X Op V
invert_left($+, T, V) -> T - V;
invert_left($-, T, V) -> T + V;
invert_left($*, T, V) -> T div V;
invert_left($/, T, V) -> T * V.

%% Target = V Op X
invert_right($+, T, V) -> T - V;
invert_right($-, T, V) -> V - T;
invert_right($*, T, V) -> T div V;
invert_right($/, T, V) -> V div T.
