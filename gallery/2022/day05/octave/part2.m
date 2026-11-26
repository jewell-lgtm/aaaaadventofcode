% Part 2: the CrateMover 9001 lifts several crates at once, so the slice
% keeps its order: the same move as part 1 without the fliplr.
function answer = part2(input)
  [stacks, moves] = crates(input);
  for m = moves
    [count, from, to] = deal(m(1), m(2), m(3));
    stacks{to} = [stacks{to} stacks{from}(end-count+1:end)];
    stacks{from}(end-count+1:end) = [];
  end
  answer = cellfun(@(s) s(end), stacks);
end
