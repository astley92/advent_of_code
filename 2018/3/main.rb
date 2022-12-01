require "byebug"

class Patch
  def self.from(string)
    id, dims = string.split(" @ ")
    coords, sizes = dims.split(": ")
    x, y = coords.split(",")
    width, height = sizes.split("x")
    new(id: id, x: x.to_i, y: y.to_i, width: width.to_i, height: height.to_i)
  end

  attr_reader :x, :y, :width, :height, :id, :right, :bottom
  def initialize(id:, x:, y:, width:, height:)
    @x = x
    @y = y
    @width = width
    @height = height
    @id = id
    @right = x + width
    @bottom = y + height
  end

  def coords
    [].tap do |res|
      (x...right).each do |cx|
        (y...bottom).each do |cy|
          res << "#{cx},#{cy}"
        end
      end
    end
  end
end

def fetch_input
  # TODO: Fix this monstrosity
  File.read((caller[-1].split(":")[0].split("/")[0..-2] + ["input.txt"]).join("/"))
end

def run(input)
  patches = input.map { Patch.from(_1) }
  seen = {}
  patches.each do |patch|
    patch.coords.each do |coord|
      if seen[coord]
        seen[coord] += 1
      else
        seen[coord] = 1
      end
    end
  end
  seen.count { |k, v| v >= 2 }.to_s
end

def run2(input)
  patches = input.map { Patch.from(_1) }
  seen = {}
  patches.each do |patch|
    patch.coords.each do |coord|
      if seen[coord]
        seen[coord] += 1
      else
        seen[coord] = 1
      end
    end
  end

  patches.each do |patch|
    return patch.id if patch.coords.all? { |coord| seen[coord] == 1 }
  end
end

input = fetch_input.split("\n")
puts "Part One: #{run(input)}"
puts "Part Two: #{run2(input)}"
