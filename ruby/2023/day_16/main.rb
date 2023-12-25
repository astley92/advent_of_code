require_relative("/Users/blakeastley/Projects/advent_of_code/ruby/runner.rb")
require("byebug")

runner = Runner.new
runner.add_test(:part_one, expected: 46, skip: false, input: <<~'MSG')
.|...\....
|.-.\.....
.....|-...
........|.
..........
.........\
..../.\\..
.-.-/..|..
.|....-|.\
..//.|....
MSG

runner.add_test(:part_two, expected: 51, skip: false, input: <<~'MSG')
.|...\....
|.-.\.....
.....|-...
........|.
..........
.........\
..../.\\..
.-.-/..|..
.|....-|.\
..//.|....
MSG

module Solution
  module_function

  def part_one(raw_input)
    grid = parse(raw_input)
    run_for(Vector.new(0,0), Vector.new(1,0), grid)
  end

  def part_two(raw_input)
    grid = parse(raw_input)
    width = grid.first.count
    height = grid.count
    max = 0
    width.times do |x|
      grid.each { |line| line.each(&:reset!) }
      result = run_for(Vector.new(x,0), Vector.new(0,1), grid)

      if result > max
        max = result
      end

      grid.each { |line| line.each(&:reset!) }
      result = run_for(Vector.new(x,height-1), Vector.new(0,-1), grid)

      if result > max
        max = result
      end
    end

    height.times do |y|
      grid.each { |line| line.each(&:reset!) }
      result = run_for(Vector.new(0,y), Vector.new(1,0), grid)

      if result > max
        max = result
      end

      grid.each { |line| line.each(&:reset!) }
      result = run_for(Vector.new(width-1,y), Vector.new(-1,0), grid)

      if result > max
        max = result
      end
    end

    max
  end

  def parse(input)
    input
      .split("\n")
      .map do |line|
        line = line.chars.map { |t| Tile.create_from(t) }
      end
  end

  def run_for(start, start_dir, grid)
    width = grid.first.count
    height = grid.count
    beams = [[start, start_dir]]
    while beams.any?
      new_beams = []
      beams.each do |position, direction|
        tile = grid[position.y][position.x]
        next if tile.has_seen_dir?(direction)

        tile.add_dir(direction)
        tile.energize!
        if tile.is_a?(Space)
          new_beams << [position + direction, direction]
        elsif tile.is_a?(VerticalSplitter) || tile.is_a?(HorizontalSplitter)
          resulting_beams = tile.split(position, direction)
          new_beams += resulting_beams
        elsif tile.is_a?(Mirror)
          new_beams << tile.reflect_beam(position, direction)
        else
          raise NotImplementedError, tile.inspect
        end

      end
      beams = new_beams.select { valid_position?(_1[0], width, height) }
    end
    grid.flatten.select { _1.energized? }.count
  end

  def valid_position?(pos, width, height)
    pos.x >= 0 && pos.x < width && pos.y >= 0 && pos.y < height
  end

  def display_grid(grid)
    grid.each do |line|
      puts line.map {_1.display_char}.join
    end
  end

  class Tile
    def self.create_from(c)
      case c
      when "."
        Space.new(".")
      when "|"
        VerticalSplitter.new("|")
      when "-"
        HorizontalSplitter.new("-")
      when "/", "\\"
        Mirror.new(c)
      end
    end

    attr_reader :character
    def initialize(c)
      @character = c
      @energized = false
      @seen_dirs = []
    end

    def reset!
      @energized = false
      @seen_dirs = []
    end

    def display_char
      if self.is_a?(Space)
        @energized ? "#" : "."
      else
        @character
      end
    end

    def energized?
      @energized
    end

    def energize!
      @energized = true
    end

    def add_dir(direction)
      @seen_dirs << direction
    end

    def has_seen_dir?(direction)
      @seen_dirs.any? { _1 == direction }
    end
  end

  class Space < Tile
  end

  class VerticalSplitter < Tile
    def split(pos, dir)
      return [[pos+dir, dir]] if dir.x == 0

      return [
        [Vector.new(pos.x, pos.y-1), Vector.new(0, -1)],
        [Vector.new(pos.x, pos.y+1), Vector.new(0, 1)]
      ]
    end
  end

  class HorizontalSplitter < Tile
    def split(pos, dir)
      return [[pos+dir, dir]] if dir.y == 0

      return [
        [Vector.new(pos.x-1, pos.y), Vector.new(-1, 0)],
        [Vector.new(pos.x+1, pos.y), Vector.new(1, 0)]
      ]
    end
  end

  class Mirror < Tile
    def reflect_beam(position, direction)
      case character
      when "/"
        case direction.human_name
        when :left
          [position.down, Vector.down]
        when :right
          [position.up, Vector.up]
        when :up
          [position.right, Vector.right]
        when :down
          [position.left, Vector.left]
        end
      when "\\"
        case direction.human_name
        when :left
          [position.up, Vector.up]
        when :right
          [position.down, Vector.down]
        when :up
          [position.left, Vector.left]
        when :down
          [position.right, Vector.right]
        end
      end
    end
  end

  class Vector
    def self.up
      new(0, -1)
    end

    def self.down
      new(0,1)
    end

    def self.left
      new(-1,0)
    end

    def self.right
      new(1,0)
    end

    attr_reader :x, :y
    def initialize(x, y)
      @x = x
      @y = y
    end

    def +(other)
      raise NotImplementedError, other.inspect unless other.is_a?(Vector)

      self.class.new(x + other.x, y + other.y)
    end

    def ==(other)
      raise NotImplementedError, other.inspect unless other.is_a?(Vector)

      other.x == x && other.y == y
    end

    def human_name
      case [x, y]
      when [0,1]
        :down
      when [0,-1]
        :up
      when [1,0]
        :right
      when [-1,0]
        :left
      end
    end

    def up
      self.class.new(x, y-1)
    end

    def down
      self.class.new(x, y+1)
    end

    def left
      self.class.new(x-1, y)
    end

    def right
      self.class.new(x+1, y)
    end
  end
end

# Part One Description
# --- Day 16: The Floor Will Be Lava ---
# With the beam of light completely focused somewhere, the reindeer leads you
# deeper still into the Lava Production Facility. At some point, you realize that
# the steel facility walls have been replaced with cave, and the doorways are just
# cave, and the floor is cave, and you're pretty sure this is actually just a
# giant cave.
#
# Finally, as you approach what must be the heart of the mountain, you see a
# bright light in a cavern up ahead. There, you discover that the beam of light
# you so carefully focused is emerging from the cavern wall closest to the
# facility and pouring all of its energy into a contraption on the opposite side.
#
# Upon closer inspection, the contraption appears to be a flat, two-dimensional
# square grid containing empty space (.), mirrors (/ and \), and splitters (| and
# -).
#
# The contraption is aligned so that most of the beam bounces around the grid,
# but each tile on the grid converts some of the beam's light into heat to melt
# the rock in the cavern.
#
# You note the layout of the contraption (your puzzle input). For example:
#
# .|...\....
# |.-.\.....
# .....|-...
# ........|.
# ..........
# .........\
# ..../.\\..
# .-.-/..|..
# .|....-|.\
# ..//.|....
#
# The beam enters in the top-left corner from the left and heading to the right.
# Then, its behavior depends on what it encounters as it moves:
#
#
# If the beam encounters empty space (.), it continues in the same direction.
# If the beam encounters a mirror (/ or \), the beam is reflected 90 degrees
# depending on the angle of the mirror. For instance, a rightward-moving beam that
# encounters a / mirror would continue upward in the mirror's column, while a
# rightward-moving beam that encounters a \ mirror would continue downward from
# the mirror's column.
# If the beam encounters the pointy end of a splitter (| or -), the beam passes
# through the splitter as if the splitter were empty space. For instance, a
# rightward-moving beam that encounters a - splitter would continue in the same
# direction.
# If the beam encounters the flat side of a splitter (| or -), the beam is split
# into two beams going in each of the two directions the splitter's pointy ends
# are pointing. For instance, a rightward-moving beam that encounters a | splitter
# would split into two beams: one that continues upward from the splitter's column
# and one that continues downward from the splitter's column.
#
# Beams do not interact with other beams; a tile can have many beams passing
# through it at the same time. A tile is energized if that tile has at least one
# beam pass through it, reflect in it, or split in it.
#
# In the above example, here is how the beam of light bounces around the
# contraption:
#
# >|<<<\....
# |v-.\^....
# .v...|->>>
# .v...v^.|.
# .v...v^...
# .v...v^..\
# .v../2\\..
# <->-/vv|..
# .|<<<2-|.\
# .v//.|.v..
#
# Beams are only shown on empty tiles; arrows indicate the direction of the
# beams. If a tile contains beams moving in multiple directions, the number of
# distinct directions is shown instead. Here is the same diagram but instead only
# showing whether a tile is energized (#) or not (.):
#
# ######....
# .#...#....
# .#...#####
# .#...##...
# .#...##...
# .#...##...
# .#..####..
# ########..
# .#######..
# .#...#.#..
#
# Ultimately, in this example, 46 tiles become energized.
#
# The light isn't energizing enough tiles to produce lava; to debug the
# contraption, you need to start by analyzing the current situation. With the beam
# starting in the top-left heading right, how many tiles end up being energized?

input = File.read(__FILE__.gsub("main.rb", "input.txt"))

runner.run!(input)
