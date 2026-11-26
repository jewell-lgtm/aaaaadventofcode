// humn is the unknown. Walk down from root along the side that depends on humn,
// inverting each operation against the value of the constant side.
import java.util.*;

class Part2 {
    static final String HUMAN = "humn";

    static boolean dependsOnHuman(Map<String, Part1.Job> jobs, String name) {
        return name.equals(HUMAN) || switch (jobs.get(name)) {
            case Part1.Num n -> false;
            case Part1.Op(var l, var op, var r) -> dependsOnHuman(jobs, l) || dependsOnHuman(jobs, r);
        };
    }

    /** The value humn must shout for monkey `name` to yield `target`. */
    static long solveFor(Map<String, Part1.Job> jobs, String name, long target) {
        if (name.equals(HUMAN)) return target;
        if (!(jobs.get(name) instanceof Part1.Op(var l, var op, var r))) throw new IllegalStateException(name + " is constant");
        if (dependsOnHuman(jobs, l)) {
            long v = Part1.eval(jobs, r); // target = x op v
            return solveFor(jobs, l, switch (op) {
                case '+' -> target - v;
                case '-' -> target + v;
                case '*' -> target / v;
                default -> target * v;
            });
        }
        long v = Part1.eval(jobs, l); // target = v op x
        return solveFor(jobs, r, switch (op) {
            case '+' -> target - v;
            case '-' -> v - target;
            case '*' -> target / v;
            default -> v / target;
        });
    }

    static Object solve(String input) {
        var jobs = Part1.parse(input);
        var root = (Part1.Op) jobs.get("root");
        return dependsOnHuman(jobs, root.left())
            ? solveFor(jobs, root.left(), Part1.eval(jobs, root.right()))
            : solveFor(jobs, root.right(), Part1.eval(jobs, root.left()));
    }
}
