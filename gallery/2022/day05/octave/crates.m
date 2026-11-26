% Shared: parse the drawing into a cell array of stacks (char rows, bottom
% first) and the moves into a 3-by-N matrix of [count; from; to].
% char() pads the drawing lines into a matrix, so crate letters sit in
% columns 2, 6, 10, ... and one indexing step reads them all.
function [stacks, moves] = crates(input)
  parts = strsplit(input, "\n\n");
  rows = strsplit(parts{1}, "\n");
  n = max(sscanf(rows{end}, '%d'));

  drawing = char(rows(1:end-1));
  drawing(:, end+1:4*n) = ' ';
  letters = drawing(end:-1:1, 2:4:4*n);
  stacks = arrayfun(@(j) letters(letters(:, j) ~= ' ', j)', 1:n, 'UniformOutput', false);

  moves = reshape(sscanf(parts{2}, ' move %d from %d to %d'), 3, []);
end
