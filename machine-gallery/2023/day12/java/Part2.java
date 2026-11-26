// Unfold each row five times (springs joined by '?'), then reuse the memoised count.
import java.util.*;
import java.util.stream.*;

class Part2 {
    static Part1.Row unfold(Part1.Row row) {
        var springs = String.join("?", Collections.nCopies(5, row.springs()));
        var groups = IntStream.range(0, 5).flatMap(i -> Arrays.stream(row.groups())).toArray();
        return new Part1.Row(springs, groups);
    }

    static Object solve(String input) {
        return input.lines().filter(l -> !l.isBlank()).map(Part1.Row::parse).map(Part2::unfold)
            .mapToLong(Part1.Row::arrangements).sum();
    }
}
