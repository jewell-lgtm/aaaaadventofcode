// Harness helpers.
//   example: true when running an example (aoc test).
//   arg('size', 71): example-specific constant from examples.toml `args`, else the default.
import 'dart:convert';
import 'dart:io';

final bool example = Platform.environment['AOC_EXAMPLE'] == '1';

final Map<String, dynamic> _args =
    jsonDecode(Platform.environment['AOC_ARGS'] ?? '{}') as Map<String, dynamic>;

T arg<T>(String name, T fallback) => _args.containsKey(name) ? _args[name] as T : fallback;
