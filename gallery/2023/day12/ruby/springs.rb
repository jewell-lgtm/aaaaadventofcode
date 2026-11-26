# Shared: memoised recursion over (index, group) with a Hash whose default block computes misses.
module Springs
  def self.arrangements(row, groups)
    memo = Hash.new do |h, (i, g)|
      h[[i, g]] =
        if i >= row.size then g == groups.size ? 1 : 0
        else
          operational = row[i] == "#" ? 0 : h[[i + 1, g]]
          size = groups[g]
          damaged = row[i] != "." && size && fits?(row, i, size) ? h[[i + size + 1, g + 1]] : 0
          operational + damaged
        end
    end
    memo[[0, 0]]
  end

  # A damaged run of `size` can start at i: no '.' inside and not followed by '#'.
  def self.fits?(row, i, size) = i + size <= row.size && !row[i, size].include?(".") && row[i + size] != "#"

  def self.total(input, copies)
    input.lines.sum do |line|
      row, groups = line.split
      arrangements(([row] * copies).join("?"), groups.split(",").map(&:to_i) * copies)
    end
  end
end
