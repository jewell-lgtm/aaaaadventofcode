// Parse the drawing column by column into ArrayDeques (top of stack = head), then
// replay moves. A record holds each parsed move.
import java.util.*;
import java.util.regex.*;
import java.util.stream.*;

class Part1 {
    record Move(int count, int from, int to) {}

    record Ship(List<Deque<Character>> stacks, List<Move> moves) {
        String tops() {
            return stacks.stream().map(s -> String.valueOf(s.peek())).collect(Collectors.joining());
        }
    }

    static Ship parse(String input) {
        var sections = input.split("\n\n", 2);
        var drawing = sections[0].lines().toList();
        var labels = drawing.getLast().strip().split("\\s+");
        var stacks = new ArrayList<Deque<Character>>();
        for (int i = 0; i < labels.length; i++) {
            var stack = new ArrayDeque<Character>();
            int col = 1 + 4 * i;
            for (var row : drawing.subList(0, drawing.size() - 1)) {
                if (col < row.length() && Character.isLetter(row.charAt(col))) stack.addLast(row.charAt(col));
            }
            stacks.add(stack);
        }
        var nums = Pattern.compile("move (\\d+) from (\\d+) to (\\d+)");
        var moves = nums.matcher(sections[1]).results()
            .map(m -> new Move(Integer.parseInt(m.group(1)), Integer.parseInt(m.group(2)) - 1, Integer.parseInt(m.group(3)) - 1))
            .toList();
        return new Ship(stacks, moves);
    }

    static Object solve(String input) {
        var ship = parse(input);
        for (var m : ship.moves()) {
            for (int i = 0; i < m.count(); i++) ship.stacks().get(m.to()).push(ship.stacks().get(m.from()).pop());
        }
        return ship.tops();
    }
}
