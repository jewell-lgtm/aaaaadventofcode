% Part 1: resolve the whole tree level by level (see resolve.m) and read
% root. The puzzle's divisions are exact, so doubles hold every integer.
function answer = part1(input)
  m = monkeys(input);
  value = resolve(m);
  answer = value(strcmp(m.names, 'root'));
end
