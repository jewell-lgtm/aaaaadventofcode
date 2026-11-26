% Part 2: make humn unknown (NaN) and resolve; exactly the monkeys on the
% path to humn stay NaN. Walk that path top-down from root, inverting each
% operation against its known operand, so every target is an exact integer.
function answer = part2(input)
  m = monkeys(input);
  humn = find(strcmp(m.names, 'humn'));
  m.value(humn) = NaN;
  value = resolve(m);

  node = find(strcmp(m.names, 'root'));
  [node, target] = unknown_side(m, value, node);   % root: both sides equal
  while node ~= humn
    [next, known, humnLeft] = unknown_side(m, value, node);
    target = invert(m.op(node), target, known, humnLeft);
    node = next;
  end
  answer = target;
end

% The operand of `node` that depends on humn, and the value of the other one.
function [child, known, humnLeft] = unknown_side(m, value, node)
  humnLeft = isnan(value(m.lhs(node)));
  if humnLeft
    [child, known] = deal(m.lhs(node), value(m.rhs(node)));
  else
    [child, known] = deal(m.rhs(node), value(m.lhs(node)));
  end
end

% Solve  x op k = t  (humn on the left) or  k op x = t  for x.
function x = invert(op, t, k, humnLeft)
  switch op
    case '+', x = t - k;
    case '*', x = t / k;
    case '-', if humnLeft, x = t + k; else, x = k - t; end
    case '/', if humnLeft, x = t * k; else, x = k / t; end
  end
end
