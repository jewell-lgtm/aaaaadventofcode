# Shared: parse into a Hash of Integer | [left, op, right]; Rational keeps division exact.
module MonkeyMath
  def self.parse(input)
    input.lines(chomp: true).to_h do |line|
      name, job = line.split(": ")
      parts = job.split
      [name, parts.size == 1 ? job.to_i : parts]
    end
  end

  def self.evaluate(tree, name)
    case tree[name]
    in Integer => n then n.to_r
    in [left, op, right] then evaluate(tree, left).public_send(op, evaluate(tree, right))
    end
  end

  def self.depends_on?(tree, name, target = "humn")
    return true if name == target

    case tree[name]
    in [left, _, right] then depends_on?(tree, left, target) || depends_on?(tree, right, target)
    else false
    end
  end
end
