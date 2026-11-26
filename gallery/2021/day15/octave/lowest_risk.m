% Shared: shortest path without a priority queue. A run of steps in one
% direction is a prefix scan: dist(c) = P(c) + cummin(dist - P) along a row,
% with P = cumsum(risk). Sweeping right, left, down and up until nothing
% changes converges in a handful of whole-matrix passes (Bellman-Ford, vectorised).
function total = lowest_risk(risk)
  dist = inf(size(risk));
  dist(1, 1) = 0;
  do
    before = dist;
    dist = sweep(dist, risk);                               % right
    dist = fliplr(sweep(fliplr(dist), fliplr(risk)));       % left
    dist = sweep(dist', risk')';                            % down
    dist = flipud(sweep(flipud(dist)', flipud(risk)')');    % up
  until isequal(dist, before)
  total = dist(end, end);
end

% Relax every row left to right in one go: entering a cell costs its risk.
function dist = sweep(dist, risk)
  P = cumsum(risk, 2);
  dist = P + cummin(dist - P, 2);
end
