%% Camel Cards: lists:sort on {{Type, Strengths}, Bid}; Erlang term order compares
%% tuples and lists element-wise, so the key is the comparator. The hand type is a
%% case on the group sizes, largest first.
-module(part1).
-export([solve/1, winnings/2]).

hand_type(Cards, Jokers) ->
    {J, Rest} = case Jokers of
                    true -> {length([C || C <- Cards, C =:= $J]), [C || C <- Cards, C =/= $J]};
                    false -> {0, Cards}
                end,
    Counts = lists:foldl(fun(C, M) -> maps:update_with(C, fun(N) -> N + 1 end, 1, M) end, #{}, Rest),
    Groups = case lists:reverse(lists:sort(maps:values(Counts))) of
                 [] -> [J];
                 [Biggest | Others] -> [Biggest + J | Others]
             end,
    case Groups of
        [5] -> 6;
        [4, 1] -> 5;
        [3, 2] -> 4;
        [3, 1, 1] -> 3;
        [2, 2, 1] -> 2;
        [2, 1, 1, 1] -> 1;
        _ -> 0
    end.

winnings(Input, Jokers) ->
    Order = case Jokers of true -> "J23456789TQKA"; false -> "23456789TJQKA" end,
    Strength = maps:from_list(lists:zip(Order, lists:seq(1, length(Order)))),
    Hands = [begin
                 [Hand, Bid] = binary:split(Line, <<" ">>),
                 Cards = binary_to_list(Hand),
                 {{hand_type(Cards, Jokers), [maps:get(C, Strength) || C <- Cards]}, binary_to_integer(Bid)}
             end || Line <- aoc:lines(Input)],
    lists:sum([Rank * Bid || {Rank, {_, Bid}} <- lists:enumerate(lists:sort(Hands))]).

solve(Input) -> winnings(Input, false).
