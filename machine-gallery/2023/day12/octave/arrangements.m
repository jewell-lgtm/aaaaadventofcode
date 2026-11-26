% Shared: bottom-up DP. ways(i, j) counts arrangements of springs(i:end)
% using groups(j:end). Rows fill from the end of the string; each row is
% computed for all groups at once, so only the position loop is in Octave code.
function total = arrangements(input, copies)
  total = 0;
  for line = strsplit(strtrim(input), "\n")
    [springs, rest] = strtok(line{1});
    groups = sscanf(rest, '%d,')';
    springs = strjoin(repmat({springs}, 1, copies), '?');
    total += count_ways(springs, repmat(groups, 1, copies));
  end
end

function w = count_ways(s, g)
  n = numel(s);
  m = numel(g);
  run = zeros(1, n + 1);          % run(i): length of the '#'/'?' stretch starting at i
  for i = n:-1:1
    run(i) = (s(i) ~= '.') * (run(i + 1) + 1);
  end
  after = [s '.'];                % a group must not be followed by '#'

  % Row n+1 is the empty suffix; row n+2 is "a group just ended at n".
  ways = zeros(n + 2, m + 1);
  ways(n + 1:n + 2, m + 1) = 1;
  for i = n:-1:1
    if s(i) ~= '#'                % treat s(i) as '.': skip it
      ways(i, :) = ways(i + 1, :);
    end
    if s(i) ~= '.'                % treat s(i) as the start of group j
      fits = run(i) >= g & after(min(i + g, n + 1)) ~= '#';
      next = min(i + g + 1, n + 2);
      ways(i, 1:m) += fits .* ways(sub2ind(size(ways), next, 2:m + 1));
    end
  end
  w = ways(1, 1);
end
