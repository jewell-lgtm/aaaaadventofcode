// Three entries summing to 2020: fix one number, then reuse part 1's pair search on the rest.
import java.util.*;

class Part2 {
    static Object solve(String input) {
        var nums = Part1.parse(input);
        for (int i = 0; i < nums.size(); i++) {
            int a = nums.get(i);
            var pair = Part1.pairProduct(nums.subList(i + 1, nums.size()), Part1.TARGET - a);
            if (pair.isPresent()) return a * pair.getAsLong();
        }
        throw new IllegalStateException("no triple sums to " + Part1.TARGET);
    }
}
