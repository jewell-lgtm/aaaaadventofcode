# Monkeys form an expression tree: a Hash from name to `Job`, a union of
# Int64 (a shouted number) and an `Op` record. Evaluation is a recursive
# `case ... in` over the union, which the compiler checks is exhaustive.
module Part1
  record Op, left : String, operator : Char, right : String
  alias Job = Int64 | Op

  class Riddle
    getter jobs : Hash(String, Job)

    def initialize(input : String)
      @jobs = input.lines.reject(&.blank?).to_h do |line|
        name, job = line.split(": ")
        parts = job.split
        {name, parts.size == 3 ? Op.new(parts[0], parts[1][0], parts[2]).as(Job) : job.to_i64.as(Job)}
      end
    end

    def eval(name : String) : Int64
      case job = jobs[name]
      in Int64 then job
      in Op    then Riddle.apply(job.operator, eval(job.left), eval(job.right))
      end
    end

    def self.apply(operator : Char, a : Int64, b : Int64) : Int64
      case operator
      when '+' then a + b
      when '-' then a - b
      when '*' then a * b
      when '/' then a // b
      else          raise "unknown operator #{operator}"
      end
    end
  end

  def self.solve(input : String)
    Riddle.new(input).eval("root")
  end
end
