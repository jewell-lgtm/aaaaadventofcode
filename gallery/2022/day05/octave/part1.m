% Part 1: stacks are char rows (top = end), so a move is slicing off the top
% `count` crates and appending them reversed with fliplr.
function answer = part1(input)
  [stacks, moves] = crates(input);
  for m = moves
    [count, from, to] = deal(m(1), m(2), m(3));
    stacks{to} = [stacks{to} fliplr(stacks{from}(end-count+1:end))];
    stacks{from}(end-count+1:end) = [];
  end
  answer = cellfun(@(s) s(end), stacks);
end
