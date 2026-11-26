// Count arrangements with a memoised recursion over (position in springs, groups placed).
// Each row gets a small long[][] memo table; -1 marks "not computed yet".
import java.util.*;

class Part1 {
    record Row(String springs, int[] groups) {
        static Row parse(String line) {
            var parts = line.split(" ");
            return new Row(parts[0], Arrays.stream(parts[1].split(",")).mapToInt(Integer::parseInt).toArray());
        }

        long arrangements() {
            var memo = new long[springs.length() + 1][groups.length + 1];
            for (var row : memo) Arrays.fill(row, -1);
            return count(0, 0, memo);
        }

        private long count(int i, int g, long[][] memo) {
            if (i >= springs.length()) return g == groups.length ? 1 : 0;
            if (memo[i][g] >= 0) return memo[i][g];
            char ch = springs.charAt(i);
            long ways = 0;
            if (ch != '#') ways += count(i + 1, g, memo); // treat as operational
            if (ch != '.' && g < groups.length && fits(i, groups[g])) {
                ways += count(i + groups[g] + 1, g + 1, memo); // place the group plus a gap
            }
            return memo[i][g] = ways;
        }

        /** A damaged group of length n can start at i: no '.' inside, no '#' right after. */
        private boolean fits(int i, int n) {
            if (i + n > springs.length()) return false;
            if (springs.substring(i, i + n).contains(".")) return false;
            return i + n == springs.length() || springs.charAt(i + n) != '#';
        }
    }

    static Object solve(String input) {
        return input.lines().filter(l -> !l.isBlank()).map(Row::parse).mapToLong(Row::arrangements).sum();
    }
}
