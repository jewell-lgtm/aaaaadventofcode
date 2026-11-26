// Scan corrupted memory for mul(X,Y) with java.util.regex; Matcher.results() turns
// matches into a stream we can sum directly.
import java.util.regex.*;

class Part1 {
    static final Pattern MUL = Pattern.compile("mul\\((\\d{1,3}),(\\d{1,3})\\)");

    static long product(MatchResult m) {
        return Long.parseLong(m.group(1)) * Long.parseLong(m.group(2));
    }

    static Object solve(String input) {
        return MUL.matcher(input).results().mapToLong(Part1::product).sum();
    }
}
