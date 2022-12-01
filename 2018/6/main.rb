require "byebug"

def fetch_input
  # TODO: Fix this monstrosity
  File.read((caller[-1].split(":")[0].split("/")[0..-2] + ["input.txt"]).join("/"))
end

class Id
  def self.generate
    instance.generate
  end

  def self.instance
    @instance ||= new
  end

  def initialize
    @count = 0
  end

  def generate
    @count += 1
    count - 1
  end

  private
  attr_accessor :count
end

class Point
  def self.from(string)
    new(*string.split(", ").map(&:to_i), Id.generate)
  end

  attr_reader :x, :y, :id
  attr_accessor :section_coords
  def initialize(x, y, id)
    @x = x
    @y = y
    @id = id
    @section_coords = []
  end

  def distance_from(coord)
    x_diff = (x - coord[0]).abs
    y_diff = (y - coord[1]).abs
    x_diff + y_diff
  end

  def x_touching?(min, max)
    xs.min == min || xs.max == max
  end

  def y_touching?(min, max)
    ys.min == min || ys.max == max
  end

  def ys
    section_coords.flat_map { _1[1] }
  end

  def xs
    section_coords.flat_map { _1[0] }
  end
end

class Pointlist
  include Enumerable

  attr_reader :points
  def initialize(points)
    @points = points
  end

  def largest_x
    points.max_by { _1.x }.x
  end

  def largest_y
    points.max_by { _1.y }.y
  end

  def each
    points.each do |point|
      yield(point)
    end
  end

  def closest_to(coord)
    closest = nil
    closest_distance = nil
    multiple_closest = false
    each do |point|
      if closest.nil?
        closest = point
        closest_distance = point.distance_from(coord)
      else
        distance = point.distance_from(coord)
        if distance < closest_distance
          multiple_closest = false
          closest = point
          closest_distance = distance
        elsif distance == closest_distance
          multiple_closest = true
        end
      end
    end
    return nil if multiple_closest
    return closest
  end

  def total_distance_to(coord)
    total = 0
    each do |point|
      total += point.distance_from(coord)
    end
    total
  end
end

class Grid
  attr_reader :width, :height
  def initialize(width, height)
    @width = width
    @height = height
  end

  def grid
    @grid ||= begin
      row = []
      width.times { row << "." }
      res = []
      height.times { res << row.clone }
      res
    end
  end

  def to_s
    grid.map { _1.join }.join("\n")
  end

  def mark!(x, y, value)
    spot = grid[y][x]
    return unless spot == "."

    grid[y][x] = value
  end

  def each_with_index
    index = 0
    (0..width-1).each do |x|
      (0..height-1).each do |y|
        index += 1
        yield([x, y], index)
      end
    end
  end

  def [](x, y)
    grid[y][x]
  end

  def inspect
    # Too big to print out on every error
    nil
  end
end

def run(input)
  pointlist = Pointlist.new(input.map { Point.from(_1) })
  width = pointlist.largest_x + 1
  height = pointlist.largest_y + 1
  grid = Grid.new(width, height)
  pointlist.each do |point|
    grid.mark!(point.x, point.y, point.id)
  end

  grid.each_with_index do |coord, index|
    print("\r#{index} of #{grid.height * grid.width} ".rjust(20, " "))
    closest = pointlist.closest_to(coord)
    next if closest.nil?

    grid.mark!(coord[0], coord[1], closest.id)
    closest.section_coords << coord
  end
  print("\r")

  valid_points = pointlist.reject { _1.x_touching?(0, grid.width-1) || _1.y_touching?(0, grid.height-1) }
  valid_points.map { _1.section_coords.count }.max
end

def run2(input)
  max_total_dist = 10_000
  pointlist = Pointlist.new(input.map { Point.from(_1) })
  width = pointlist.largest_x + 1
  height = pointlist.largest_y + 1
  grid = Grid.new(width, height)
  pointlist.each do |point|
    grid.mark!(point.x, point.y, point.id)
  end

  total = 0
  grid.each_with_index do |coord, index|
    print("\r#{index} of #{grid.height * grid.width} ".rjust(20, " "))
    distance = pointlist.total_distance_to(coord)
    next if distance > max_total_dist

    grid.mark!(coord[0], coord[1], "#")
    total += 1
  end
  print("\r")
  total
end

input = fetch_input.split("\n")

puts "Part One: #{run(input)}".ljust(20, " ")
puts "Part Two: #{run2(input)}".ljust(20, " ")
