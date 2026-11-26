# humn sits on exactly one path from root. Evaluate the other branch at each
# node, then invert the operator to push the required value down that path
# until it reaches humn. Note `-` and `/` invert differently per side.
module Part2
  class Solver < Part1::Riddle
    @humn_below = {} of String => Bool

    def depends_on_humn?(name : String) : Bool
      @humn_below.fetch(name) do
        job = jobs[name]
        @humn_below[name] = name == "humn" ||
          (job.is_a?(Part1::Op) && (depends_on_humn?(job.left) || depends_on_humn?(job.right)))
      end
    end

    # The value `name` must yield so that its parent ends up as `target`.
    def solve(name : String, target : Int64) : Int64
      return target if name == "humn"
      job = jobs[name].as(Part1::Op)
      if depends_on_humn?(job.left)
        known = eval(job.right)
        solve(job.left, case job.operator
          when '+' then target - known
          when '-' then target + known
          when '*' then target // known
          else          target * known
          end)
      else
        known = eval(job.left)
        solve(job.right, case job.operator
          when '+' then target - known
          when '-' then known - target
          when '*' then target // known
          else          known // target
          end)
      end
    end

    def humn_for_equal_root : Int64
      root = jobs["root"].as(Part1::Op)
      if depends_on_humn?(root.left)
        solve(root.left, eval(root.right))
      else
        solve(root.right, eval(root.left))
      end
    end
  end

  def self.solve(input : String)
    Solver.new(input).humn_for_equal_root
  end
end
