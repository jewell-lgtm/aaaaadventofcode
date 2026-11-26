// Camel Cards, part 2: J is a joker: weakest card, but it joins the largest group for the type.
// Dart: Map.remove returns the joker count before it's added to the biggest group.
import 'cards.dart';

Object solve(String input) => winnings(input, 'J23456789TQKA', jokers: true);
