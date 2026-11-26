% Shared: rank every hand at once. Card counts come from one accumarray into
% an N-by-13 matrix; sum(counts.^2) orders the hand types (25 five of a kind
% ... 5 high card) with no case analysis. sortrows on [type cards] gives ranks.
function total = winnings(input, order, jokers)
  toks = regexp(input, '(\S{5}) (\d+)', 'tokens');
  toks = vertcat(toks{:});
  [~, cards] = ismember(char(toks(:, 1)), order);
  bids = str2double(toks(:, 2));

  n = rows(cards);
  counts = accumarray([repmat((1:n)', 5, 1), cards(:)], 1, [n 13]);
  if jokers
    % Jokers (order(1)) join whichever card is already most common.
    js = counts(:, 1);
    counts(:, 1) = 0;
    [~, best] = max(counts, [], 2);
    idx = sub2ind(size(counts), (1:n)', best);
    counts(idx) += js;
  end

  [~, ranked] = sortrows([sum(counts .^ 2, 2), cards]);
  total = sum((1:n)' .* bids(ranked));
end
