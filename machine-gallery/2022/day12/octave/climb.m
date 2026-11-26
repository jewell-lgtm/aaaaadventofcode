% Shared: BFS as a wavefront of logical masks. Each step shifts the frontier
% one cell in the four directions, keeps the moves the height rule allows
% (climb at most 1), and drops cells already seen: whole-matrix ops, no queue.
function steps = climb(input, startChars)
  grid = char(strsplit(strtrim(input), "\n"));
  height = double(grid);
  height(grid == 'S') = 'a';
  height(grid == 'E') = 'z';

  frontier = ismember(grid, startChars);
  seen = frontier;
  steps = 0;
  while ~any(frontier(grid == 'E'))
    frontier = expand(frontier, height) & ~seen;
    if ~any(frontier(:)), error('climb: E is unreachable'); end
    seen = seen | frontier;
    steps++;
  end
end

% Cells reachable in one step from the frontier, one direction at a time.
function next = expand(frontier, h)
  next = false(size(h));
  ok = @(from, to) to <= from + 1;
  next(1:end-1, :) |= frontier(2:end, :) & ok(h(2:end, :), h(1:end-1, :));
  next(2:end, :)   |= frontier(1:end-1, :) & ok(h(1:end-1, :), h(2:end, :));
  next(:, 1:end-1) |= frontier(:, 2:end) & ok(h(:, 2:end), h(:, 1:end-1));
  next(:, 2:end)   |= frontier(:, 1:end-1) & ok(h(:, 1:end-1), h(:, 2:end));
end
