// Rank hands with a Comparator chain: hand type first, then card-by-card strength.
// A record per hand, an enum for the types, and the Comparator combinators do the rest.
import java.util.*;
import java.util.function.ToIntFunction;
import java.util.stream.*;

class Part1 {
    record Hand(String cards, long bid) {}

    enum Type { HIGH_CARD, ONE_PAIR, TWO_PAIR, THREE, FULL_HOUSE, FOUR, FIVE }

    /** Type from the card counts sorted descending, e.g. [3, 2] = full house. */
    static Type typeOf(List<Integer> counts) {
        return switch (counts.get(0)) {
            case 5 -> Type.FIVE;
            case 4 -> Type.FOUR;
            case 3 -> counts.get(1) == 2 ? Type.FULL_HOUSE : Type.THREE;
            case 2 -> counts.get(1) == 2 ? Type.TWO_PAIR : Type.ONE_PAIR;
            default -> Type.HIGH_CARD;
        };
    }

    static List<Integer> counts(String cards) {
        return cards.chars().boxed()
            .collect(Collectors.groupingBy(c -> c, Collectors.summingInt(c -> 1)))
            .values().stream().sorted(Comparator.reverseOrder()).collect(Collectors.toCollection(ArrayList::new));
    }

    static List<Hand> parse(String input) {
        return input.lines().filter(l -> !l.isBlank()).map(l -> l.split(" "))
            .map(p -> new Hand(p[0], Long.parseLong(p[1]))).toList();
    }

    /** Compare by type, then by each card's index in the strength order. */
    static Comparator<Hand> byStrength(ToIntFunction<Hand> type, String order) {
        Comparator<Hand> cmp = Comparator.comparingInt(type);
        for (int i = 0; i < 5; i++) {
            int at = i;
            cmp = cmp.thenComparingInt(h -> order.indexOf(h.cards().charAt(at)));
        }
        return cmp;
    }

    static long winnings(List<Hand> hands, Comparator<Hand> order) {
        var ranked = hands.stream().sorted(order).toList();
        return IntStream.range(0, ranked.size()).mapToLong(i -> (i + 1) * ranked.get(i).bid()).sum();
    }

    static Object solve(String input) {
        return winnings(parse(input), byStrength(h -> typeOf(counts(h.cards())).ordinal(), "23456789TJQKA"));
    }
}
