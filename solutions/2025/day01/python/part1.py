def solve(input: str) -> int:
    pos, zeros = 50, 0
    for line in input.strip().split('\n'):
        delta = int(line[1:]) * (-1 if line[0] == 'L' else 1)
        pos = (pos + delta) % 100
        zeros += pos == 0
    return zeros
