// Two entries summing to 2020: one pass over a HashSet of numbers seen so far.
// Plain Java: parse with streams, then an ordinary loop where it reads best.
import java.util.*;

class Part1 {
    static final int TARGET = 2020;

    static List<Integer> parse(String input) {
        return input.lines().filter(l -> !l.isBlank()).map(String::strip).map(Integer::parseInt).toList();
    }

    /** Some a, b in nums with a + b == target, as a * b. */
    static OptionalLong pairProduct(List<Integer> nums, int target) {
        var seen = new HashSet<Integer>();
        for (int n : nums) {
            if (seen.contains(target - n)) return OptionalLong.of((long) n * (target - n));
            seen.add(n);
        }
        return OptionalLong.empty();
    }

    static Object solve(String input) {
        return pairProduct(parse(input), TARGET).orElseThrow();
    }
}
