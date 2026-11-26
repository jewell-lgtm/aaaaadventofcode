// Harness entry: don't edit. stdin = input, AOC_PART = 1|2, prints the answer last.
import java.io.IOException;

class Main {
    public static void main(String[] args) throws IOException {
        var input = new String(System.in.readAllBytes());
        var answer = "2".equals(System.getenv("AOC_PART")) ? Part2.solve(input) : Part1.solve(input);
        System.out.println(answer);
    }
}
