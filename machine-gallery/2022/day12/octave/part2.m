% Part 2: the mask BFS starts from every lowest cell at once; a multi-source
% start is just a bigger initial mask.
function answer = part2(input)
  answer = climb(input, 'Sa');
end
