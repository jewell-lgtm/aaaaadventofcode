// Harness helpers.
import Foundation

/// True when running an example (aoc test).
let example = ProcessInfo.processInfo.environment["AOC_EXAMPLE"] == "1"

nonisolated(unsafe) private let args: [String: Any] = {
  let json = ProcessInfo.processInfo.environment["AOC_ARGS"] ?? "{}"
  return (try? JSONSerialization.jsonObject(with: Data(json.utf8))) as? [String: Any] ?? [:]
}()

/// Example-specific constant from examples.toml `args`, else the real-input default.
func arg<T>(_ name: String, _ fallback: T) -> T {
  args[name] as? T ?? fallback
}
