% Part 1: one regexp with 'tokens' pulls every well-formed mul(X,Y);
% the tokens stack into an N-by-2 cell that str2double turns into a matrix,
% so the answer is a row-wise product and a sum.
function answer = part1(input)
  toks = regexp(input, 'mul\((\d{1,3}),(\d{1,3})\)', 'tokens');
  pairs = str2double(vertcat(toks{:}));
  answer = sum(prod(pairs, 2));
end
