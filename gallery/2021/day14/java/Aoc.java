// Harness helpers.
//   Aoc.example: true when running an example (aoc test).
//   Aoc.arg("size", 71): example-specific constant from examples.toml `args`, else the default.
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;

final class Aoc {
    private Aoc() {}

    static final boolean example = "1".equals(System.getenv("AOC_EXAMPLE"));

    private static final Map<String, String> ARGS = parseFlat(System.getenv().getOrDefault("AOC_ARGS", "{}"));

    static int arg(String name, int fallback) { return ARGS.containsKey(name) ? Integer.parseInt(ARGS.get(name)) : fallback; }
    static long arg(String name, long fallback) { return ARGS.containsKey(name) ? Long.parseLong(ARGS.get(name)) : fallback; }
    static boolean arg(String name, boolean fallback) { return ARGS.containsKey(name) ? Boolean.parseBoolean(ARGS.get(name)) : fallback; }
    static String arg(String name, String fallback) { return ARGS.getOrDefault(name, fallback); }

    // Flat JSON object {"k": 1, "s": "x", "b": true}: enough for AOC_ARGS (no JSON in the JDK).
    private static Map<String, String> parseFlat(String json) {
        var m = Pattern.compile("\"([^\"]*)\"\\s*:\\s*(?:\"([^\"]*)\"|([^,}\\s]+))").matcher(json);
        var out = new HashMap<String, String>();
        while (m.find()) out.put(m.group(1), m.group(2) != null ? m.group(2) : m.group(3));
        return out;
    }
}
