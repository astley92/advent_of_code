##### Part One Description #####
# --- Day 18: Boiling Boulders ---
# You and the elephants finally reach fresh air. You've emerged near the base of
# a large volcano that seems to be actively erupting! Fortunately, the lava seems
# to be flowing away from you and toward the ocean.
#
# Bits of lava are still being ejected toward you, so you're sheltering in the
# cavern exit a little longer. Outside the cave, you can see the lava landing in a
# pond and hear it loudly hissing as it solidifies.
#
# Depending on the specific compounds in the lava and speed at which it cools, it
# might be forming obsidian! The cooling rate should be based on the surface area
# of the lava droplets, so you take a quick scan of a droplet as it flies past you
# (your puzzle input).
#
# Because of how quickly the lava is moving, the scan isn't very good; its
# resolution is quite low and, as a result, it approximates the shape of the lava
# droplet with 1x1x1 cubes on a 3D grid, each given as its x,y,z position.
#
# To approximate the surface area, count the number of sides of each cube that
# are not immediately connected to another cube. So, if your scan were only two
# adjacent cubes like 1,1,1 and 2,1,1, each cube would have a single side covered
# and five sides exposed, a total surface area of 10 sides.
#
# Here's a larger example:
#
# 2,2,2
# 1,2,2
# 3,2,2
# 2,1,2
# 2,3,2
# 2,2,1
# 2,2,3
# 2,2,4
# 2,2,6
# 1,2,5
# 3,2,5
# 2,1,5
# 2,3,5
#
# In the above example, after counting up all the sides that aren't connected to
# another cube, the total surface area is 64.
#
# What is the surface area of your scanned lava droplet?
require "set"

DIR_VECS = [
  [0,0,1],
  [0,0,-1],
  [0,1,0],
  [0,-1,0],
  [1,0,0],
  [-1,0,0],
]
class Cube
  attr_reader :x, :y, :z
  attr_accessor :connected_to

  def initialize(x, y, z)
    @x = x
    @y = y
    @z = z
  end

  def ==(other)
    other.x == x && other.y == y && other.z == z
  end
end

def self.parse_input(input)
  # Parse input
  input.split("\n").map do |line|
    x, y, z = line.split(",").map(&:to_i)
    Cube.new(x, y, z)
  end
end

def part_one(input)
  res = 0
  input.each do |cube|
    DIR_VECS.each do |dir_vec|
      neighbour_cube = Cube.new(cube.x + dir_vec[0], cube.y + dir_vec[1], cube.z + dir_vec[2])
      res += 1 unless input.include?(neighbour_cube)
    end
  end
  res
end

def part_two(input)
  x_dims = (input.map(&:x).min..input.map(&:x).max)
  y_dims = (input.map(&:y).min..input.map(&:y).max)
  z_dims = (input.map(&:z).min..input.map(&:z).max)

  res = 0
  input.each_with_index do |cube, index|
    DIR_VECS.each do |dir_vec|
      neighbour_cube = Cube.new(cube.x + dir_vec[0], cube.y + dir_vec[1], cube.z + dir_vec[2])
      res += 1 if can_escape?(neighbour_cube, x_dims, y_dims, z_dims, input)
    end
  end
  res
end

@can_escape_from = []
@cannot_escape_from = []

def can_escape?(cube, x_dims, y_dims, z_dims, other_cubes)
  stack = [[cube, []]]
  visited = []
  while stack.any?
    current, path = stack.pop
    return true if @can_escape_from.include?(current)
    return false if @cannot_escape_from.include?(current)

    next if (other_cubes + visited).include? current

    if !(x_dims.include? current.x) || !(y_dims.include? current.y) || !(z_dims.include? current.z)
      path.each { @can_escape_from << _1 }
      return true
    end

    visited << current
    DIR_VECS.each do |dir_vec|
      neighbour_cube = Cube.new(current.x + dir_vec[0], current.y + dir_vec[1], current.z + dir_vec[2])
      stack << [neighbour_cube, path + [current]]
    end
  end

  visited.uniq.each { @cannot_escape_from << _1 }
  return false
end

input = File.read(__FILE__.gsub("main.rb", "input.txt"))
puts "Part One: #{part_one(parse_input(input))}"
puts "Part Two: #{part_two(parse_input(input))}"
