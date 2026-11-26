// One alternation regex finds mul(...), do() and don't() in order; a switch on the
// matched token flips the enabled flag.
import java.util.regex.*;

class Part2 {
    static final Pattern TOKEN = Pattern.compile("mul\\((\\d{1,3}),(\\d{1,3})\\)|do\\(\\)|don't\\(\\)");

    static Object solve(String input) {
        boolean enabled = true;
        long sum = 0;
        for (var m : TOKEN.matcher(input).results().toList()) {
            switch (m.group()) {
                case "do()" -> enabled = true;
                case "don't()" -> enabled = false;
                default -> { if (enabled) sum += Part1.product(m); }
            }
        }
        return sum;
    }
}
