def solve(input: str) -> int:
    pos, zeros = 50, 0
    for line in input.strip().split('\n'):
        dist = int(line[1:])
        if line[0] == 'L':
            zeros += dist // 100 if pos == 0 else (dist - pos) // 100 + 1 if dist >= pos else 0
            pos = (pos - dist) % 100
        else:
            zeros += dist // 100 if pos == 0 else (dist + pos - 100) // 100 + 1 if dist + pos >= 100 else 0
            pos = (pos + dist) % 100
    return zeros
