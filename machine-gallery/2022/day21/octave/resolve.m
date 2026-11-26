% Shared: evaluate the tree bottom-up as a wavefront. Each pass computes every
% waiting monkey whose two operands are known, one vectorised op at a time;
% the loop runs once per tree level. Unknown leaves (NaN) stay unresolved.
function value = resolve(m)
  value = m.value;
  waiting = find(m.op ~= ' ');
  while true
    ready = waiting(isnan(value(waiting)) & ...
                    ~isnan(value(m.lhs(waiting))) & ~isnan(value(m.rhs(waiting))));
    if isempty(ready), break; end
    a = value(m.lhs(ready));
    b = value(m.rhs(ready));
    op = m.op(ready);
    v = a + b;
    v(op == '-') = a(op == '-') - b(op == '-');
    v(op == '*') = a(op == '*') .* b(op == '*');
    v(op == '/') = a(op == '/') ./ b(op == '/');
    value(ready) = v;
  end
end
