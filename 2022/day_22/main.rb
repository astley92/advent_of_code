##### Part One Description #####
# --- Day 22: Monkey Map ---
# The monkeys take you on a surprisingly easy trail through the jungle. They're
# even going in roughly the right direction according to your handheld device's
# Grove Positioning System.
#
# As you walk, the monkeys explain that the grove is protected by a force field.
# To pass through the force field, you have to enter a password; doing so involves
# tracing a specific path on a strangely-shaped board.
#
# At least, you're pretty sure that's what you have to do; the elephants aren't
# exactly fluent in monkey.
#
# The monkeys give you notes that they took when they last saw the password
# entered (your puzzle input).
#
# For example:
#
#         ...#
#         .#..
#         #...
#         ....
# ...#.......#
# ........#...
# ..#....#....
# ..........#.
#         ...#....
#         .....#..
#         .#......
#         ......#.
#
# 10R5L5R10L4R5L5
#
# The first half of the monkeys' notes is a map of the board. It is comprised of
# a set of open tiles (on which you can move, drawn .) and solid walls (tiles
# which you cannot enter, drawn #).
#
# The second half is a description of the path you must follow. It consists of
# alternating numbers and letters:
#
#
# A number indicates the number of tiles to move in the direction you are facing.
# If you run into a wall, you stop moving forward and continue with the next
# instruction.
# A letter indicates whether to turn 90 degrees clockwise (R) or counterclockwise
# (L). Turning happens in-place; it does not change your current tile.
#
# So, a path like 10R5 means "go forward 10 tiles, then turn clockwise 90
# degrees, then go forward 5 tiles".
#
# You begin the path in the leftmost open tile of the top row of tiles.
# Initially, you are facing to the right (from the perspective of how the map is
# drawn).
#
# If a movement instruction would take you off of the map, you wrap around to the
# other side of the board. In other words, if your next tile is off of the board,
# you should instead look in the direction opposite of your current facing as far
# as you can until you find the opposite edge of the board, then reappear there.
#
# For example, if you are at A and facing to the right, the tile in front of you
# is marked B; if you are at C and facing down, the tile in front of you is marked
# D:
#
#         ...#
#         .#..
#         #...
#         ....
# ...#.D.....#
# ........#...
# B.#....#...A
# .....C....#.
#         ...#....
#         .....#..
#         .#......
#         ......#.
#
# It is possible for the next tile (after wrapping around) to be a wall; this
# still counts as there being a wall in front of you, and so movement stops before
# you actually wrap to the other side of the board.
#
# By drawing the last facing you had with an arrow on each tile you visit, the
# full path taken by the above example looks like this:
#
#         >>v#
#         .#v.
#         #.v.
#         ..v.
# ...#...v..v#
# >>>v...>#.>>
# ..#v...#....
# ...>>>>v..#.
#         ...#....
#         .....#..
#         .#......
#         ......#.
#
# To finish providing the password to this strange input device, you need to
# determine numbers for your final row, column, and facing as your final position
# appears from the perspective of the original map. Rows start from 1 at the top
# and count downward; columns start from 1 at the left and count rightward. (In
# the above example, row 1, column 1 refers to the empty space with no tile on it
# in the top-left corner.) Facing is 0 for right (>), 1 for down (v), 2 for left
# (<), and 3 for up (^). The final password is the sum of 1000 times the row, 4
# times the column, and the facing.
#
# In the above example, the final row is 6, the final column is 8, and the final
# facing is 0. So, the final password is 1000 * 6 + 4 * 8 + 0: 6032.
#
# Follow the path given in the monkeys' notes. What is the final password?
require "byebug"

class Grid
  def self.pad_strings(strings)
    max = strings.max_by { _1.count }.count
    strings.each do |s|
      while s.count < max
        s << " "
      end
    end
  end

  def self.from_string(string)
    new(
      rows: pad_strings(string.split("\n").map(&:chars)),
    )
  end

  attr_reader :rows
  def initialize(rows:)
    @rows = rows
  end

  def start_pos
    @rows.first.each_with_index do |e, x|
      if e == "."
        return [x, 0]
      end
    end
  end

  def is_wall?(coords)
    @rows[coords[1]][coords[0]] == "#"
  end

  def wrap(pos, direction)
    x, y = pos
    if ["E", "W"].include? direction
      if x >= x_range_for(y).last
        x = x_range_for(y).first
      elsif x < x_range_for(y).first
        x = x_range_for(y).last
      end
    else
      if y >= y_range_for(x).last
        y = y_range_for(x).first
      elsif y < y_range_for(x).first
        y = y_range_for(x).last
      end
    end
    [x, y]
  end

  private

  def x_range_for(y)
    min = nil
    max = nil
    started = false

    @rows[y].each_with_index do |char, index|
      if [".", "#"].include?(char)
        if !started
          min = index
          started = true
        end
      else
        if started
          max = index
          started = false
        end
      end
    end
    if max.nil?
      max = @rows[y].count-1
    end
    (min..max)
  end

  def y_range_for(x)
    min = nil
    max = nil
    started = false
    @rows.transpose[x].each_with_index do |char, index|
      if [".", "#"].include?(char)
        if !started
          min = index
          started = true
        end
      else
        if started
          max = index
          started = false
        end
      end
    end
    if max.nil?
      max = @rows.transpose[x].count-1
    end
    (min..max)
  end
end

class Movements
  def self.from_string(string)
    movements = []
    string.strip.split(/(L|R)/).each do |m|
      if ["R", "L"].include? m
        movements << m
      else
        movements << m.to_i
      end
    end
    new(movements: movements)
  end

  def initialize(movements:)
    @movements = movements
  end

  def each
    @movements.each { yield(_1) }
  end
end

class Position
  DIRECTIONS = {
    "E" => {
      dir_vec: [1, 0],
      left: "N",
      right: "S",
    },
    "W" => {
      dir_vec: [-1, 0],
      left: "S",
      right: "N"
    },
    "N" => {
      dir_vec: [0, -1],
      left: "W",
      right: "E"
    },
    "S" => {
      dir_vec: [0, 1],
      left: "E",
      right: "W",
    },
  }

  attr_reader :direction
  def initialize(x, y)
    @x = x
    @y = y
    @direction = "E"
  end

  def forward_one
    dir_vec = DIRECTIONS.dig(@direction, :dir_vec)
    [@x + dir_vec[0], @y + dir_vec[1]]
  end

  def update_pos(coords)
    @x = coords[0]
    @y = coords[1]
  end

  def rotate(dir)
    direction_key = dir == "L" ? :left : :right
    @direction = DIRECTIONS.dig(@direction, direction_key)
  end

  def pos
    [@x, @y]
  end
end

def self.parse_input(input)
  grid_strings, movement_string = input.split("\n\n")
  grid = Grid.from_string(grid_strings)
  movements = Movements.from_string(movement_string)
  [grid, movements]
end

def part_one(input)
  grid, movements = input
  current = Position.new(*grid.start_pos)
  movements.each do |move|
    if move.is_a?(Integer)
      move.times do
        puts current.pos.inspect + " " + current.direction
        forward_one = grid.wrap(current.forward_one, current.direction)
        if grid.is_wall?(forward_one)
          break
        end
        current.update_pos(forward_one)
      end
    else
      current.rotate(move)
    end
  end
  row = current.pos[1] + 1
  col = current.pos[0] + 1
  dir_scores = {"E" => 0, "S" => 1, "W" => 2, "N" => 3}
  facing = dir_scores.fetch(current.direction)


  (1000 * row) + (4 * col) + (facing)
end

def part_two(input)
  # Solve part two
end

input = File.read(__FILE__.gsub("main.rb", "input.txt"))
puts "Part One: #{part_one(parse_input(input))}"
puts "Part Two: #{part_two(parse_input(input))}"
