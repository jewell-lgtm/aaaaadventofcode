// Shared: the hand type as an enum, then a comparator chaining type and card ranks.
enum HandType { highCard, onePair, twoPair, three, fullHouse, four, five }

HandType handType(String hand, {required bool jokers}) {
  final counts = <String, int>{};
  for (final c in hand.split('')) {
    counts[c] = (counts[c] ?? 0) + 1;
  }
  final wild = jokers ? counts.remove('J') ?? 0 : 0;
  final groups = counts.values.toList()..sort((a, b) => b - a);
  if (groups.isEmpty) groups.add(0);
  groups[0] += wild;
  return switch (groups) {
    [5] => HandType.five,
    [4, ...] => HandType.four,
    [3, 2] => HandType.fullHouse,
    [3, ...] => HandType.three,
    [2, 2, ...] => HandType.twoPair,
    [2, ...] => HandType.onePair,
    _ => HandType.highCard,
  };
}

int winnings(String input, String order, {bool jokers = false}) {
  final hands = [
    for (final [hand, bid] in input.trim().split('\n').map((l) => l.split(' ')))
      (type: handType(hand, jokers: jokers), ranks: hand.split('').map(order.indexOf).toList(), bid: int.parse(bid)),
  ];
  hands.sort((a, b) {
    if (a.type != b.type) return a.type.index - b.type.index;
    for (var i = 0; i < a.ranks.length; i++) {
      if (a.ranks[i] != b.ranks[i]) return a.ranks[i] - b.ranks[i];
    }
    return 0;
  });
  var total = 0;
  for (final (i, h) in hands.indexed) {
    total += (i + 1) * h.bid;
  }
  return total;
}
