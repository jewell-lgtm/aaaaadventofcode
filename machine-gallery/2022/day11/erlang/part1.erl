%% Monkey in the Middle: each block is destructured by binary prefix patterns into a
%% record whose op is a fun; rounds fold over a map of held items. Relief is `div 3`
%% here and `rem` the product of all divisors in part 2.
-module(part1).
-export([solve/1, monkey_business/3]).
-include("monkey.hrl").

parse_monkey(Block) ->
    [_Header,
     <<"  Starting items: ", Items/binary>>,
     <<"  Operation: new = old ", Op, " ", Arg/binary>>,
     <<"  Test: divisible by ", Divisor/binary>>,
     <<"    If true: throw to monkey ", OnTrue/binary>>,
     <<"    If false: throw to monkey ", OnFalse/binary>>] = aoc:lines(Block),
    {[binary_to_integer(I) || I <- binary:split(Items, <<", ">>, [global])],
     #monkey{op = operation(Op, Arg),
             divisor = binary_to_integer(Divisor),
             on_true = binary_to_integer(OnTrue),
             on_false = binary_to_integer(OnFalse)}}.

operation($*, <<"old">>) -> fun(X) -> X * X end;
operation($*, N) -> M = binary_to_integer(N), fun(X) -> X * M end;
operation($+, N) -> M = binary_to_integer(N), fun(X) -> X + M end.

monkey_business(Input, Rounds, Relief) ->
    Parsed = lists:enumerate(0, [parse_monkey(B) || B <- binary:split(Input, <<"\n\n">>, [global, trim_all])]),
    Monkeys = [{I, M} || {I, {_, M}} <- Parsed],
    Held = maps:from_list([{I, Items} || {I, {Items, _}} <- Parsed]),
    Relieve = Relief([M || {_, M} <- Monkeys]),
    Round = fun(_, State) -> lists:foldl(fun(IM, S) -> turn(IM, S, Relieve) end, State, Monkeys) end,
    {_, Inspected} = lists:foldl(Round, {Held, #{}}, lists:seq(1, Rounds)),
    [A, B | _] = lists:reverse(lists:sort(maps:values(Inspected))),
    A * B.

turn({I, #monkey{op = Op, divisor = D, on_true = T, on_false = F}}, {Held, Inspected}, Relieve) ->
    Items = maps:get(I, Held),
    Throw = fun(Worry0, H) ->
                Worry = Relieve(Op(Worry0)),
                Target = case Worry rem D of 0 -> T; _ -> F end,
                maps:update_with(Target, fun(L) -> L ++ [Worry] end, H)
            end,
    {lists:foldl(Throw, Held#{I := []}, Items),
     maps:update_with(I, fun(N) -> N + length(Items) end, length(Items), Inspected)}.

solve(Input) -> monkey_business(Input, 20, fun(_) -> fun(W) -> W div 3 end end).
