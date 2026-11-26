// Camel Cards, part 1: classify each hand with a switch on list patterns, then sort.
// Dart: list patterns like [3, 2] and [4, ...] name the hand types directly.
import 'cards.dart';

Object solve(String input) => winnings(input, '23456789TJQKA');
