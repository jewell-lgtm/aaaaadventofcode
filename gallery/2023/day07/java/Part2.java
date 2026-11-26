// Jokers: count them separately and add them to the largest group of real cards,
// and J becomes the weakest card in the tie-break order.
import java.util.*;

class Part2 {
    static Part1.Type jokerType(String cards) {
        int jokers = (int) cards.chars().filter(c -> c == 'J').count();
        var counts = jokers == 5 ? new ArrayList<Integer>(List.of(0)) : Part1.counts(cards.replace("J", ""));
        counts.set(0, counts.get(0) + jokers);
        return Part1.typeOf(counts);
    }

    static Object solve(String input) {
        return Part1.winnings(Part1.parse(input), Part1.byStrength(h -> jokerType(h.cards()).ordinal(), "J23456789TQKA"));
    }
}
