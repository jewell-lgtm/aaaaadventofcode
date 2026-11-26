// Don't build the polymer: track how often each adjacent pair occurs. Each rule
// AB -> C turns every AB into AC and CB. Element counts come from the pairs' first letters.
import java.util.*;

class Part1 {
    record Puzzle(String template, Map<String, Character> rules) {}

    static Puzzle parse(String input) {
        var sections = input.split("\n\n");
        var rules = new HashMap<String, Character>();
        sections[1].lines().filter(l -> !l.isBlank()).map(l -> l.split(" -> "))
            .forEach(p -> rules.put(p[0], p[1].charAt(0)));
        return new Puzzle(sections[0].strip(), rules);
    }

    static long spread(Puzzle p, int steps) {
        var pairs = new HashMap<String, Long>();
        for (int i = 0; i + 1 < p.template().length(); i++) pairs.merge(p.template().substring(i, i + 2), 1L, Long::sum);

        for (int s = 0; s < steps; s++) {
            var next = new HashMap<String, Long>();
            pairs.forEach((pair, n) -> {
                Character mid = p.rules().get(pair);
                if (mid == null) { next.merge(pair, n, Long::sum); return; }
                next.merge("" + pair.charAt(0) + mid, n, Long::sum);
                next.merge("" + mid + pair.charAt(1), n, Long::sum);
            });
            pairs = next;
        }

        var counts = new HashMap<Character, Long>();
        pairs.forEach((pair, n) -> counts.merge(pair.charAt(0), n, Long::sum));
        counts.merge(p.template().charAt(p.template().length() - 1), 1L, Long::sum); // last letter starts no pair
        var stats = counts.values().stream().mapToLong(Long::longValue).summaryStatistics();
        return stats.getMax() - stats.getMin();
    }

    static Object solve(String input) {
        return spread(parse(input), 10);
    }
}
