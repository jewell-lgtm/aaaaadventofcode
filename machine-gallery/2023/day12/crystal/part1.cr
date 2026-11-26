# Count arrangements with a memoised recursion over (position, group index).
# The memo is a Hash keyed by a tuple; each step either treats the current
# spring as operational or places the next damaged group right here.
module Part1
  class Arrangements
    @memo = {} of {Int32, Int32} => Int64

    def initialize(@springs : String, @groups : Array(Int32))
    end

    def count(at : Int32 = 0, group : Int32 = 0) : Int64
      key = {at, group}
      @memo[key]? || (@memo[key] = compute(at, group))
    end

    private def compute(at : Int32, group : Int32) : Int64
      return (group == @groups.size ? 1_i64 : 0_i64) if at >= @springs.size

      total = 0_i64
      spring = @springs[at]
      total += count(at + 1, group) unless spring == '#'
      if spring != '.' && group < @groups.size && fits?(at, @groups[group])
        total += count(at + @groups[group] + 1, group + 1)
      end
      total
    end

    # A run of `size` damaged springs can start at `at` and is then followed
    # by the end of the row or something that can be operational.
    private def fits?(at : Int32, size : Int32) : Bool
      stop = at + size
      stop <= @springs.size &&
        !@springs[at...stop].includes?('.') &&
        @springs[stop]? != '#'
    end
  end

  def self.records(input : String) : Array({String, Array(Int32)})
    input.lines.reject(&.blank?).map do |line|
      springs, groups = line.split
      {springs, groups.split(',').map(&.to_i)}
    end
  end

  def self.solve(input : String)
    records(input).sum { |springs, groups| Arrangements.new(springs, groups).count }
  end
end
