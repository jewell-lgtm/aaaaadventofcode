% Shared: items never interact, so track them as two vectors (worry, owner)
% instead of per-monkey queues. A monkey's turn is a logical mask over the
% items it holds: update them all at once, then rewrite their owners.
% Operations are parsed to new = old^pow * mul + add, so no function handles.
function answer = monkey_business(input, rounds, relief)
  blocks = strsplit(strtrim(input), "\n\n");
  n = numel(blocks);
  [pow, mul, add, divisor, onTrue, onFalse] = deal(zeros(n, 1));
  worry = []; owner = [];
  for m = 1:n
    b = blocks{m};
    items = str2double(regexp(field(b, 'items:([^\n]*)'), '\d+', 'match'))';
    worry = [worry; items];
    owner = [owner; m * ones(size(items))];
    op = regexp(b, 'new = old (.) (\S+)', 'tokens', 'once');
    [pow(m), mul(m), add(m)] = parse_op(op{:});
    divisor(m) = str2double(field(b, 'divisible by (\d+)'));
    onTrue(m)  = str2double(field(b, 'true: throw to monkey (\d+)')) + 1;
    onFalse(m) = str2double(field(b, 'false: throw to monkey (\d+)')) + 1;
  end

  % Divisibility by every monkey's test survives reduction mod their product.
  % Reducing before squaring keeps worry < 1e7 and squares < 2^53: exact doubles.
  modulus = prod(divisor);
  inspected = zeros(n, 1);
  for r = 1:rounds
    for m = 1:n
      held = owner == m;
      inspected(m) += nnz(held);
      w = worry(held) .^ pow(m) * mul(m) + add(m);
      if relief, w = floor(w / 3); else, w = mod(w, modulus); end
      worry(held) = w;
      targets = [onFalse(m) onTrue(m)];
      owner(held) = targets(1 + (mod(w, divisor(m)) == 0));
    end
  end
  top = sort(inspected, 'descend');
  answer = top(1) * top(2);
end

function [pow, mul, add] = parse_op(op, arg)
  [pow, mul, add] = deal(1, 1, 0);
  if strcmp(arg, 'old')
    if op == '*', pow = 2; else, mul = 2; end
  elseif op == '*'
    mul = str2double(arg);
  else
    add = str2double(arg);
  end
end

% The single captured token of `pattern` in block text `b`.
function s = field(b, pattern)
  tok = regexp(b, pattern, 'tokens', 'once');
  s = tok{1};
end
