% Shared: track pair counts, not the polymer. Pairs index a 676-vector and
% one insertion step is a sparse 676x676 matrix (AB -> AC + CB, pairs without
% a rule map to themselves), so n steps are n sparse matrix-vector products.
function spread = polymer(input, steps)
  parts = strsplit(strtrim(input), "\n\n");
  template = strtrim(parts{1}) - 'A' + 1;
  rules = regexp(parts{2}, '([A-Z])([A-Z]) -> ([A-Z])', 'tokens');
  rules = cell2mat(vertcat(rules{:})) - 'A' + 1;  % N-by-3: A, B, C

  pair = @(a, b) (a - 1) * 26 + b;
  from = pair(rules(:, 1), rules(:, 2));
  keep = setdiff((1:676)', from);
  step = sparse([pair(rules(:, 1), rules(:, 3)); pair(rules(:, 3), rules(:, 2)); keep], ...
                [from; from; keep], 1, 676, 676);

  counts = accumarray(pair(template(1:end-1), template(2:end))', 1, [676 1]);
  for k = 1:steps
    counts = step * counts;
  end

  % Each element is counted as the first letter of its pairs, plus the last letter.
  elements = accumarray(ceil((1:676)' / 26), counts, [26 1]);
  elements(template(end)) += 1;
  present = elements(elements > 0);
  spread = max(present) - min(present);
end
