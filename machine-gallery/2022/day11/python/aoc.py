import json
import os

_ARGS = json.loads(os.environ.get("AOC_ARGS") or "{}")

#: True when running an example (aoc test).
example = os.environ.get("AOC_EXAMPLE") == "1"


def arg(name, default):
    """Example-specific constant from examples.toml `args`, else the real-input default."""
    return _ARGS.get(name, default)
