// CrateMover 9001 lifts several crates at once: pop them into a buffer, then push
// back in reverse so their order is kept.
import java.util.*;

class Part2 {
    static Object solve(String input) {
        var ship = Part1.parse(input);
        for (var m : ship.moves()) {
            var from = ship.stacks().get(m.from());
            var lifted = new ArrayDeque<Character>();
            for (int i = 0; i < m.count(); i++) lifted.push(from.pop());
            while (!lifted.isEmpty()) ship.stacks().get(m.to()).push(lifted.pop());
        }
        return ship.tops();
    }
}
