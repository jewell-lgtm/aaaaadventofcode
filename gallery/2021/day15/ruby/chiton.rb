# Shared: Dijkstra with a bucket queue (weights are 1..9), tiled risk computed on demand.
module Chiton
  def self.lowest_risk(input, tiles)
    base = input.split.map { |row| row.chars.map(&:to_i) }
    h, w = base.size, base.first.size
    rows, cols = h * tiles, w * tiles
    risk = ->(r, c) { (base[r % h][c % w] + r / h + c / w - 1) % 9 + 1 }

    dist = Hash.new(Float::INFINITY).merge([0, 0] => 0)
    buckets = Hash.new { |hash, k| hash[k] = [] }
    buckets[0] << [0, 0]
    0.step do |d|
      buckets.delete(d)&.each do |r, c|
        next if dist[[r, c]] < d
        return d if [r, c] == [rows - 1, cols - 1]

        [[r + 1, c], [r - 1, c], [r, c + 1], [r, c - 1]].each do |nr, nc|
          next unless (0...rows).cover?(nr) && (0...cols).cover?(nc)

          nd = d + risk.(nr, nc)
          next unless nd < dist[[nr, nc]]

          dist[[nr, nc]] = nd
          buckets[nd] << [nr, nc]
        end
      end
    end
  end
end
