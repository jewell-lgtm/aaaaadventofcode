% Part 2: find mul/do/don't by start position, then work out the switch in
% force at every character without a loop: mark each switch at its own
% position and run cummax, so each character sees the last switch before it.
function answer = part2(input)
  [mulAt, toks] = regexp(input, 'mul\((\d{1,3}),(\d{1,3})\)', 'start', 'tokens');
  doAt   = regexp(input, 'do\(\)', 'start');
  dontAt = regexp(input, 'don''t\(\)', 'start');

  lastSwitch = zeros(size(input));
  lastSwitch([doAt dontAt]) = [doAt dontAt];
  lastSwitch = cummax(lastSwitch);
  enabled = lastSwitch == 0 | ismember(lastSwitch, doAt);

  pairs = str2double(vertcat(toks{:}));
  answer = sum(prod(pairs(enabled(mulAt), :), 2));
end
