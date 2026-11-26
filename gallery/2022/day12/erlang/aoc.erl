%% Harness helpers.
%%   aoc:example(): true when running an example (aoc test).
%%   aoc:arg(<<"size">>, 71): example-specific constant from examples.toml `args`, else the default.
%%   aoc:lines(Input): non-empty lines as binaries.
-module(aoc).
-export([example/0, arg/2, lines/1, to_string/1]).

example() -> os:getenv("AOC_EXAMPLE") =:= "1".

arg(Name, Default) ->
    Args = json:decode(list_to_binary(os:getenv("AOC_ARGS", "{}"))),
    maps:get(Name, Args, Default).

lines(Input) -> binary:split(Input, <<"\n">>, [global, trim_all]).

to_string(X) when is_integer(X) -> integer_to_list(X);
to_string(X) when is_binary(X) -> X;
to_string(X) when is_list(X) -> X.
