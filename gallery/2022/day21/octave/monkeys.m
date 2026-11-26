% Shared: parse with two regexps, then turn names into integer ids with one
% ismember on the cellstr of names. No per-name map lookups: the tree is
% stored as vectors (lhs, op, rhs are per-monkey columns, 0 for leaves).
function m = monkeys(input)
  yells = regexp(input, '(\w+): (\d+)', 'tokens');
  waits = regexp(input, '(\w+): (\w+) (\S) (\w+)', 'tokens');
  yells = vertcat(yells{:});
  waits = vertcat(waits{:});

  m.names = [yells(:, 1); waits(:, 1)];
  nYell = rows(yells);
  n = numel(m.names);
  m.value = [str2double(yells(:, 2)); nan(rows(waits), 1)];
  [m.lhs, m.rhs] = deal(zeros(n, 1));
  m.op = repmat(' ', n, 1);
  [~, m.lhs(nYell+1:end)] = ismember(waits(:, 2), m.names);
  [~, m.rhs(nYell+1:end)] = ismember(waits(:, 4), m.names);
  m.op(nYell+1:end) = [waits{:, 3}];
end
