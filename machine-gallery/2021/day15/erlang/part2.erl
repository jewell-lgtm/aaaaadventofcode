%% Tile the cave 5x5: every tile step adds 1 to the risk, wrapping 9 back to 1.
-module(part2).
-export([solve/1]).

tile(#{rows := H, cols := W, risk := Risk}) ->
    #{rows => 5 * H, cols => 5 * W,
      risk => fun({R, C}) -> (Risk({R rem H, C rem W}) + R div H + C div W - 1) rem 9 + 1 end}.

solve(Input) -> part1:lowest_risk(tile(part1:parse(Input))).
