//! Harness helpers.
#![allow(dead_code)]

use std::str::FromStr;

/// True when running an example (aoc test).
pub fn example() -> bool {
    std::env::var("AOC_EXAMPLE").as_deref() == Ok("1")
}

/// Example-specific constant from examples.toml `args`, else the real-input default.
pub fn arg<T: FromStr>(name: &str, default: T) -> T {
    let json = std::env::var("AOC_ARGS").unwrap_or_default();
    flat_json(&json)
        .into_iter()
        .find(|(k, _)| k == name)
        .and_then(|(_, v)| v.parse().ok())
        .unwrap_or(default)
}

/// Flat JSON object {"k": 1, "s": "x", "b": true}: enough for AOC_ARGS.
fn flat_json(s: &str) -> Vec<(String, String)> {
    let mut out = Vec::new();
    let mut rest = s.trim().trim_start_matches('{').trim_end_matches('}');
    while let Some(start) = rest.find('"') {
        let after = &rest[start + 1..];
        let Some(end) = after.find('"') else { break };
        let key = after[..end].to_string();
        let value = after[end + 1..]
            .trim_start()
            .trim_start_matches(':')
            .trim_start();
        let (val, tail) = match value.strip_prefix('"') {
            Some(v) => v.split_once('"').unwrap_or((v, "")),
            None => value.split_once(',').unwrap_or((value, "")),
        };
        out.push((key, val.trim().to_string()));
        rest = tail.trim_start_matches(|c: char| c == ',' || c.is_whitespace());
    }
    out
}
