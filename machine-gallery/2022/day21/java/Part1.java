// Each monkey's job is a sealed interface: a number or an operation on two names.
// Evaluation is a recursive switch with record deconstruction patterns.
import java.util.*;

class Part1 {
    sealed interface Job permits Num, Op {}
    record Num(long value) implements Job {}
    record Op(String left, char op, String right) implements Job {}

    static Map<String, Job> parse(String input) {
        var jobs = new HashMap<String, Job>();
        for (var line : input.lines().filter(l -> !l.isBlank()).toList()) {
            var parts = line.split(": ");
            var expr = parts[1].split(" ");
            jobs.put(parts[0], expr.length == 1
                ? new Num(Long.parseLong(expr[0]))
                : new Op(expr[0], expr[1].charAt(0), expr[2]));
        }
        return jobs;
    }

    static long apply(char op, long a, long b) {
        return switch (op) {
            case '+' -> a + b;
            case '-' -> a - b;
            case '*' -> a * b;
            case '/' -> a / b;
            default -> throw new IllegalArgumentException("op " + op);
        };
    }

    static long eval(Map<String, Job> jobs, String name) {
        return switch (jobs.get(name)) {
            case Num(var value) -> value;
            case Op(var left, var op, var right) -> apply(op, eval(jobs, left), eval(jobs, right));
        };
    }

    static Object solve(String input) {
        return eval(parse(input), "root");
    }
}
