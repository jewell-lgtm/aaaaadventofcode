%% Monkey Math: each monkey is an integer or an {Op, Left, Right} tuple in a map;
%% eval recurses with one clause per shape.
-module(part1).
-export([solve/1, parse/1, eval/2]).

parse(Input) ->
    maps:from_list([parse_job(L) || L <- aoc:lines(Input)]).

parse_job(Line) ->
    [Name, Job] = binary:split(Line, <<": ">>),
    case binary:split(Job, <<" ">>, [global]) of
        [A, <<Op>>, B] -> {Name, {Op, A, B}};
        [N] -> {Name, binary_to_integer(N)}
    end.

eval(Jobs, Name) ->
    case maps:get(Name, Jobs) of
        N when is_integer(N) -> N;
        {Op, A, B} -> apply_op(Op, eval(Jobs, A), eval(Jobs, B))
    end.

apply_op($+, A, B) -> A + B;
apply_op($-, A, B) -> A - B;
apply_op($*, A, B) -> A * B;
apply_op($/, A, B) -> A div B.

solve(Input) -> eval(parse(Input), <<"root">>).
