require "json"

# Harness helpers.
#   Aoc.example?        true when running an example (aoc test)
#   Aoc.arg("size", 71) example-specific constant from examples.toml `args`, else the default
module Aoc
  ARGS = JSON.parse(ENV["AOC_ARGS"]? || "{}").as_h

  def self.example? : Bool
    ENV["AOC_EXAMPLE"]? == "1"
  end

  def self.arg(name : String, default : Int32) : Int32
    ARGS[name]?.try(&.as_i) || default
  end

  def self.arg(name : String, default : Int64) : Int64
    ARGS[name]?.try(&.as_i64) || default
  end

  def self.arg(name : String, default : Float64) : Float64
    ARGS[name]?.try { |v| v.as_f? || v.as_i.to_f } || default
  end

  def self.arg(name : String, default : String) : String
    ARGS[name]?.try(&.as_s) || default
  end

  def self.arg(name : String, default : Bool) : Bool
    v = ARGS[name]?
    v.nil? ? default : v.as_bool
  end
end
