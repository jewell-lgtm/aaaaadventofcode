%% Extended Polymerization: never build the polymer. Count adjacent pairs in a map;
%% each step, pair {A, B} with rule C becomes {A, C} and {C, B}.
%% Element counts = first letter of every pair, plus the template's last letter.
-module(part1).
-export([solve/1, spread/2]).

spread(Input, Steps) ->
    [Template | RuleLines] = aoc:lines(Input),
    Rules = maps:from_list([{{A, B}, C} || <<A, B, " -> ", C>> <- RuleLines]),
    Letters = binary_to_list(Template),
    Start = count([{{A, B}, 1} || {A, B} <- lists:zip(lists:droplast(Letters), tl(Letters))]),
    Step = fun(_, Pairs) ->
               count(lists:append([expand(P, N, Rules) || P := N <- Pairs]))
           end,
    Final = lists:foldl(Step, Start, lists:seq(1, Steps)),
    Counts = maps:values(count([{lists:last(Letters), 1} | [{A, N} || {A, _} := N <- Final]])),
    lists:max(Counts) - lists:min(Counts).

expand({A, B} = Pair, N, Rules) ->
    case Rules of
        #{Pair := C} -> [{{A, C}, N}, {{C, B}, N}];
        _ -> [{Pair, N}]
    end.

count(KVs) -> lists:foldl(fun({K, N}, M) -> maps:update_with(K, fun(X) -> X + N end, N, M) end, #{}, KVs).

solve(Input) -> spread(Input, 10).
