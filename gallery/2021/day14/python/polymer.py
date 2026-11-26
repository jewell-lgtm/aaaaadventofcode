# Shared: Counter of adjacent pairs; each rule AB -> C turns every AB into AC + CB.
from collections import Counter
from itertools import pairwise


def polymer_spread(input: str, steps: int) -> int:
    template, rules_block = input.strip().split("\n\n")
    rules = dict(line.split(" -> ") for line in rules_block.splitlines())
    pairs = Counter(a + b for a, b in pairwise(template))
    for _ in range(steps):
        nxt = Counter()
        for pair, n in pairs.items():
            if c := rules.get(pair):
                nxt[pair[0] + c] += n
                nxt[c + pair[1]] += n
            else:
                nxt[pair] += n
        pairs = nxt
    elements = Counter({template[-1]: 1})
    for pair, n in pairs.items():
        elements[pair[0]] += n
    (_, most), *_, (_, least) = elements.most_common()
    return most - least
