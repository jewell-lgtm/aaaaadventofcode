% Part 1: read the digit grid as a matrix and relax it (see lowest_risk.m).
function answer = part1(input)
  risk = char(strsplit(strtrim(input), "\n")) - '0';
  answer = lowest_risk(risk);
end
