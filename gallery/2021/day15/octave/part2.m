% Part 2: the 5x5 tiled map is repmat of the tile plus kron of the tile
% offsets (0..8), wrapped 9 -> 1 with mod. Then the same sweeps as part 1.
function answer = part2(input)
  tile = char(strsplit(strtrim(input), "\n")) - '0';
  offsets = kron((0:4)' + (0:4), ones(size(tile)));
  risk = mod(repmat(tile, 5, 5) + offsets - 1, 9) + 1;
  answer = lowest_risk(risk);
end
