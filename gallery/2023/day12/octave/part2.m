% Part 2: unfold each row five times. The DP is unchanged; the sum can reach
% ~1e14, still exact in doubles (< 2^53).
function answer = part2(input)
  answer = arrangements(input, 5);
end
