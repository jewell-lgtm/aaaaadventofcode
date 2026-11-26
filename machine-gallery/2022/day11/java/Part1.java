// Monkeys as records parsed with one regex per block; the operation becomes a
// LongUnaryOperator. Simulation mutates per-monkey ArrayDeques of worry levels.
import java.util.*;
import java.util.function.LongUnaryOperator;
import java.util.regex.*;

class Part1 {
    record Monkey(Deque<Long> items, LongUnaryOperator op, long divisor, int ifTrue, int ifFalse) {
        int target(long worry) { return worry % divisor == 0 ? ifTrue : ifFalse; }
    }

    static final Pattern BLOCK = Pattern.compile("""
        Monkey \\d+:
          Starting items: ([\\d, ]*)
          Operation: new = old ([*+]) (\\w+)
          Test: divisible by (\\d+)
            If true: throw to monkey (\\d+)
            If false: throw to monkey (\\d+)""");

    static LongUnaryOperator operation(String op, String operand) {
        if (operand.equals("old")) return op.equals("*") ? x -> x * x : x -> x + x;
        long n = Long.parseLong(operand);
        return op.equals("*") ? x -> x * n : x -> x + n;
    }

    static List<Monkey> parse(String input) {
        return BLOCK.matcher(input).results().map(m -> new Monkey(
            new ArrayDeque<>(Arrays.stream(m.group(1).split(",\\s*")).map(Long::parseLong).toList()),
            operation(m.group(2), m.group(3)),
            Long.parseLong(m.group(4)), Integer.parseInt(m.group(5)), Integer.parseInt(m.group(6))
        )).toList();
    }

    /** Runs the rounds and returns the product of the two largest inspection counts. */
    static long monkeyBusiness(List<Monkey> monkeys, int rounds, LongUnaryOperator relief) {
        var inspected = new long[monkeys.size()];
        for (int round = 0; round < rounds; round++) {
            for (int i = 0; i < monkeys.size(); i++) {
                var m = monkeys.get(i);
                while (!m.items().isEmpty()) {
                    long worry = relief.applyAsLong(m.op().applyAsLong(m.items().poll()));
                    monkeys.get(m.target(worry)).items().add(worry);
                    inspected[i]++;
                }
            }
        }
        Arrays.sort(inspected);
        return inspected[inspected.length - 1] * inspected[inspected.length - 2];
    }

    static Object solve(String input) {
        return monkeyBusiness(parse(input), 20, w -> w / 3);
    }
}
