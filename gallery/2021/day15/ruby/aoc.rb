require "json"

module Aoc
  ARGS = JSON.parse(ENV.fetch("AOC_ARGS", "").then { _1.empty? ? "{}" : _1 })

  # True when running an example (aoc test).
  def self.example? = ENV["AOC_EXAMPLE"] == "1"

  # Example-specific constant from examples.toml `args`, else the real-input default.
  def self.arg(name, default) = ARGS.fetch(name.to_s, default)
end
