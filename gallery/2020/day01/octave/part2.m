% Part 2: the same idea one dimension up. Broadcasting a column, a row and a
% page gives an n-by-n-by-n cube of triple sums (8M cells for 200 entries),
% masked to strictly increasing indices so each triple is distinct.
function answer = part2(input)
  x = sscanf(input, '%d');
  n = numel(x);
  k = 1:n;
  sums = x + x' + reshape(x, 1, 1, n);
  increasing = (k' < k) & (k < reshape(k, 1, 1, n));
  [i, j, l] = ind2sub(size(sums), find(sums == 2020 & increasing, 1));
  answer = x(i) * x(j) * x(l);
end
