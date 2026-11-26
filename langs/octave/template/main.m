% Harness entry: don't edit. stdin = input, AOC_PART = 1|2, prints the answer last.
1;
input = fread(stdin, Inf, 'char=>char')';
if strcmp(getenv('AOC_PART'), '2')
  answer = part2(input);
else
  answer = part1(input);
end
if ischar(answer)
  disp(answer);
elseif answer == fix(answer)
  printf('%d\n', answer);
else
  printf('%.15g\n', answer);
end
