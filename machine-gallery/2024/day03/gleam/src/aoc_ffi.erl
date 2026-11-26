-module(aoc_ffi).
-export([read_stdin/0, getenv/1, arg/1]).

read_stdin() ->
    ok = io:setopts(standard_io, [binary]),
    read_stdin([]).
read_stdin(Acc) ->
    case io:get_chars(standard_io, "", 65536) of
        eof -> iolist_to_binary(lists:reverse(Acc));
        Data -> read_stdin([Data | Acc])
    end.

getenv(Name) ->
    case os:getenv(binary_to_list(Name)) of
        false -> {error, nil};
        Value -> {ok, unicode:characters_to_binary(Value)}
    end.

%% AOC_ARGS values as strings (numbers re-encoded), so Gleam parses them with int.parse.
arg(Name) ->
    Args = json:decode(list_to_binary(os:getenv("AOC_ARGS", "{}"))),
    case maps:find(Name, Args) of
        {ok, V} when is_binary(V) -> {ok, V};
        {ok, V} -> {ok, iolist_to_binary(json:encode(V))};
        error -> {error, nil}
    end.
