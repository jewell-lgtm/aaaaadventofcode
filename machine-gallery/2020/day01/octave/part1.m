% Part 1: broadcasting x + x' builds every pairwise sum at once; triu keeps
% each unordered pair of distinct entries once, and find picks the hit.
function answer = part1(input)
  x = sscanf(input, '%d');
  [i, j] = find(triu(x + x' == 2020, 1), 1);
  answer = x(i) * x(j);
end
