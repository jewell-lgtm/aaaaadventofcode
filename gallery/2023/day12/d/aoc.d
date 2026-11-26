/// Harness helpers.
module aoc;

import std.json : JSONType, parseJSON;
import std.process : environment;

/// True when running an example (aoc test).
bool example() {
    return environment.get("AOC_EXAMPLE") == "1";
}

/// Example-specific constant from examples.toml `args`, else the real-input default.
T arg(T)(string name, T fallback) {
    auto json = parseJSON(environment.get("AOC_ARGS", "{}"));
    if (json.type != JSONType.object) return fallback;
    if (auto value = name in json.object) return value.get!T;
    return fallback;
}
