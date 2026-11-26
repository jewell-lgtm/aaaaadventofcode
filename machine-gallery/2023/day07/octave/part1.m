% Part 1: card strength is the position in the order string (see winnings.m).
function answer = part1(input)
  answer = winnings(input, '23456789TJQKA', false);
end
