%% Jokers: weakest for tie-breaks, wildcard for the hand type.
-module(part2).
-export([solve/1]).

solve(Input) -> part1:winnings(Input, true).
