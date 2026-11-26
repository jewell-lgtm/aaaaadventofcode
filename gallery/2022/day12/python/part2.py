# Hill Climbing Algorithm, part 2: multi-source BFS from every lowest square.
# Python: seeding the deque with all starts answers "fewest steps from any a" in one search.
from hill import shortest_path


def solve(input: str) -> int:
    return shortest_path(input, "Sa")
