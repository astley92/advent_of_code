##### Part One Description #####
# --- Day 17: Pyroclastic Flow ---
# Your handheld device has located an alternative exit from the cave for you and
# the elephants. The ground is rumbling almost continuously now, but the strange
# valves bought you some time. It's definitely getting warmer in here, though.
#
# The tunnels eventually open into a very tall, narrow chamber. Large,
# oddly-shaped rocks are falling into the chamber from above, presumably due to
# all the rumbling. If you can't work out where the rocks will fall next, you
# might be crushed!
#
# The five types of rocks have the following peculiar shapes, where # is rock and
# . is empty space:
#
# ####
#
# .#.
# ###
# .#.
#
# ..#
# ..#
# ###
#
# #
# #
# #
# #
#
# ##
# ##
#
# The rocks fall in the order shown above: first the - shape, then the + shape,
# and so on. Once the end of the list is reached, the same order repeats: the -
# shape falls first, sixth, 11th, 16th, etc.
#
# The rocks don't spin, but they do get pushed around by jets of hot gas coming
# out of the walls themselves. A quick scan reveals the effect the jets of hot gas
# will have on the rocks as they fall (your puzzle input).
#
# For example, suppose this was the jet pattern in your cave:
#
# >>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>
#
# In jet patterns, < means a push to the left, while > means a push to the right.
# The pattern above means that the jets will push a falling rock right, then
# right, then right, then left, then left, then right, and so on. If the end of
# the list is reached, it repeats.
#
# The tall, vertical chamber is exactly seven units wide. Each rock appears so
# that its left edge is two units away from the left wall and its bottom edge is
# three units above the highest rock in the room (or the floor, if there isn't
# one).
#
# After a rock appears, it alternates between being pushed by a jet of hot gas
# one unit (in the direction indicated by the next symbol in the jet pattern) and
# then falling one unit down. If any movement would cause any part of the rock to
# move into the walls, floor, or a stopped rock, the movement instead does not
# occur. If a downward movement would have caused a falling rock to move into the
# floor or an already-fallen rock, the falling rock stops where it is (having
# landed on something) and a new rock immediately begins falling.
#
# Drawing falling rocks with @ and stopped rocks with #, the jet pattern in the
# example above manifests as follows:
#
# The first rock begins falling:
# |..@@@@.|
# |.......|
# |.......|
# |.......|
# +-------+
#
# Jet of gas pushes rock right:
# |...@@@@|
# |.......|
# |.......|
# |.......|
# +-------+
#
# Rock falls 1 unit:
# |...@@@@|
# |.......|
# |.......|
# +-------+
#
# Jet of gas pushes rock right, but nothing happens:
# |...@@@@|
# |.......|
# |.......|
# +-------+
#
# Rock falls 1 unit:
# |...@@@@|
# |.......|
# +-------+
#
# Jet of gas pushes rock right, but nothing happens:
# |...@@@@|
# |.......|
# +-------+
#
# Rock falls 1 unit:
# |...@@@@|
# +-------+
#
# Jet of gas pushes rock left:
# |..@@@@.|
# +-------+
#
# Rock falls 1 unit, causing it to come to rest:
# |..####.|
# +-------+
#
# A new rock begins falling:
# |...@...|
# |..@@@..|
# |...@...|
# |.......|
# |.......|
# |.......|
# |..####.|
# +-------+
#
# Jet of gas pushes rock left:
# |..@....|
# |.@@@...|
# |..@....|
# |.......|
# |.......|
# |.......|
# |..####.|
# +-------+
#
# Rock falls 1 unit:
# |..@....|
# |.@@@...|
# |..@....|
# |.......|
# |.......|
# |..####.|
# +-------+
#
# Jet of gas pushes rock right:
# |...@...|
# |..@@@..|
# |...@...|
# |.......|
# |.......|
# |..####.|
# +-------+
#
# Rock falls 1 unit:
# |...@...|
# |..@@@..|
# |...@...|
# |.......|
# |..####.|
# +-------+
#
# Jet of gas pushes rock left:
# |..@....|
# |.@@@...|
# |..@....|
# |.......|
# |..####.|
# +-------+
#
# Rock falls 1 unit:
# |..@....|
# |.@@@...|
# |..@....|
# |..####.|
# +-------+
#
# Jet of gas pushes rock right:
# |...@...|
# |..@@@..|
# |...@...|
# |..####.|
# +-------+
#
# Rock falls 1 unit, causing it to come to rest:
# |...#...|
# |..###..|
# |...#...|
# |..####.|
# +-------+
#
# A new rock begins falling:
# |....@..|
# |....@..|
# |..@@@..|
# |.......|
# |.......|
# |.......|
# |...#...|
# |..###..|
# |...#...|
# |..####.|
# +-------+
#
# The moment each of the next few rocks begins falling, you would see this:
#
# |..@....|
# |..@....|
# |..@....|
# |..@....|
# |.......|
# |.......|
# |.......|
# |..#....|
# |..#....|
# |####...|
# |..###..|
# |...#...|
# |..####.|
# +-------+
#
# |..@@...|
# |..@@...|
# |.......|
# |.......|
# |.......|
# |....#..|
# |..#.#..|
# |..#.#..|
# |#####..|
# |..###..|
# |...#...|
# |..####.|
# +-------+
#
# |..@@@@.|
# |.......|
# |.......|
# |.......|
# |....##.|
# |....##.|
# |....#..|
# |..#.#..|
# |..#.#..|
# |#####..|
# |..###..|
# |...#...|
# |..####.|
# +-------+
#
# |...@...|
# |..@@@..|
# |...@...|
# |.......|
# |.......|
# |.......|
# |.####..|
# |....##.|
# |....##.|
# |....#..|
# |..#.#..|
# |..#.#..|
# |#####..|
# |..###..|
# |...#...|
# |..####.|
# +-------+
#
# |....@..|
# |....@..|
# |..@@@..|
# |.......|
# |.......|
# |.......|
# |..#....|
# |.###...|
# |..#....|
# |.####..|
# |....##.|
# |....##.|
# |....#..|
# |..#.#..|
# |..#.#..|
# |#####..|
# |..###..|
# |...#...|
# |..####.|
# +-------+
#
# |..@....|
# |..@....|
# |..@....|
# |..@....|
# |.......|
# |.......|
# |.......|
# |.....#.|
# |.....#.|
# |..####.|
# |.###...|
# |..#....|
# |.####..|
# |....##.|
# |....##.|
# |....#..|
# |..#.#..|
# |..#.#..|
# |#####..|
# |..###..|
# |...#...|
# |..####.|
# +-------+
#
# |..@@...|
# |..@@...|
# |.......|
# |.......|
# |.......|
# |....#..|
# |....#..|
# |....##.|
# |....##.|
# |..####.|
# |.###...|
# |..#....|
# |.####..|
# |....##.|
# |....##.|
# |....#..|
# |..#.#..|
# |..#.#..|
# |#####..|
# |..###..|
# |...#...|
# |..####.|
# +-------+
#
# |..@@@@.|
# |.......|
# |.......|
# |.......|
# |....#..|
# |....#..|
# |....##.|
# |##..##.|
# |######.|
# |.###...|
# |..#....|
# |.####..|
# |....##.|
# |....##.|
# |....#..|
# |..#.#..|
# |..#.#..|
# |#####..|
# |..###..|
# |...#...|
# |..####.|
# +-------+
#
# To prove to the elephants your simulation is accurate, they want to know how
# tall the tower will get after 2022 rocks have stopped (but before the 2023rd
# rock begins falling). In this example, the tower of rocks will be 3068 units
# tall.
#
# How many units tall will the tower of rocks be after 2022 rocks have stopped
# falling?

require "byebug"

class Shape
  def self.from_string(string)
    id = string.split("\n")[0].to_i * 1000000000000
    rows = string.split("\n")[1..]
    positions = []
    rows.reverse.each_with_index do |row, y|
      row.chars.each_with_index do |c, x|
        if c == "#"
          positions << [x, y]
        end
      end
    end

    new(
      height: rows.count,
      width: rows.first.chars.count,
      positions: positions,
      id: id,
    )
  end

  attr_reader :positions, :id
  def initialize(height:, width:, positions:, id:)
    @height = height
    @width = width
    @positions = positions
    @id = id
  end

  def top_y
    @positions.max_by { _1[1] }[1]
  end

  def min_y
    @positions.min_by { _1[1] }[1]
  end

  def apply_y_offset!(offset)
    @positions.map! { [_1[0], _1[1] + offset] }
  end

  def apply_y_offset(offset)
    @positions.map { [_1[0], _1[1] + offset] }
  end

  def apply_x_offset!(offset)
    @positions.map! { [_1[0] + offset, _1[1]] }
  end

  def apply_x_offset(offset)
    @positions.map { [_1[0] + offset, _1[1]] }
  end

  def ys
    @positions.map { _1[1] }.flatten
  end
end

require "set"

class Chamber
  attr_reader :shapes, :heights, :direction_index
  def initialize(width:, directions:, max_shapes:)
    @width = width
    @directions = directions
    @direction_index = 0
    @max_shapes = max_shapes
    @min_x = 0
    @max_x = 6
    @shapes = []
    @ids = []
    @heights = []
  end

  def can_take_more_shapes?
    @shapes.count < @max_shapes
  end

  def drop_shape(shape)
    shape.apply_y_offset!(starting_y_offset)
    shape.apply_x_offset!(2)

    resting = false
    while !resting
      direction = @directions[@direction_index] == ">" ? 1 : -1
      @direction_index += 1
      @direction_index = @direction_index % @directions.count

      if can_move_horizontally?(shape, direction)
        shape.apply_x_offset!(direction)
      end

      if can_drop?(shape)
        shape.apply_y_offset!(-1)
      else
        resting = true
      end
    end
    @shapes << shape
  end

  def height
    @shapes.max_by { _1.top_y }.top_y
  end

  def starting_y_offset
    if @shapes.empty?
      3
    else
      @shapes.max_by { _1.top_y }.top_y + 4
    end
  end

  def can_drop?(shape)
    return false unless shape.min_y > 0

    relevant_shapes = @shapes.last(100)
    dropped_positions = shape.apply_y_offset(-1)
    dropped_positions.each do |pos|
      if relevant_shapes.any? { _1.positions.include? pos }
        return false
      end
    end

    true
  end

  def can_move_horizontally?(shape, offset)
    next_positions = shape.apply_x_offset(offset)
    return false unless next_positions.all? { _1[0] >= 0 && _1[0] <= @max_x }

    relevant_shapes = @shapes.last(100)
    next_positions.each do |pos|
      if relevant_shapes.any? { _1.positions.include? pos }
        return false
      end
    end

    true
  end

  def to_s(shape=nil)
    if shape
      shapes = @shapes + [shape]
    else
      shapes = @shapes
    end
    res = []
    (shapes.max_by { _1.top_y }.top_y + 1).times do |y|
      line = ""
      7.times do |x|
        if shapes.any? { _1.positions.include? [x, y] }
          line << "#"
        else
          line << "."
        end
      end
      res << ("|" + line + "|")
    end
    res.reverse
  end

  def top_row_id
    return 0 unless @shapes.any?

    max_y = @shapes.max_by { _1.top_y }.top_y
    relevant_shapes = @shapes.select { _1.ys.include? max_y }
    ys = relevant_shapes.flat_map { _1.ys }.uniq
    ys.map { _1 * 10000000 }.sum
  end
end

def self.parse_input(input)
  input
end

def part_one(input)
  chamber = Chamber.new(width: 7, directions: input.strip.chars, max_shapes: 2022)
  shape_strings = File.read(__FILE__.gsub("main.rb", "shapes.txt")).split("\n\n")

  shape_index = 0
  while chamber.can_take_more_shapes?
    shape_index = shape_index % shape_strings.count
    current_shape = Shape.from_string(shape_strings[shape_index])
    shape_index += 1

    chamber.drop_shape(current_shape)
    puts chamber.shapes.count
  end
  chamber.height + 1
end

def part_two(input)
  chamber = Chamber.new(width: 7, directions: input.strip.chars, max_shapes: 10000000000000)
  shape_strings = File.read(__FILE__.gsub("main.rb", "shapes.txt")).split("\n\n")
  ids = []
  heights = []

  shape_index = 0
  while chamber.can_take_more_shapes?
    shape_index = shape_index % shape_strings.count
    current_shape = Shape.from_string(shape_strings[shape_index])
    shape_index += 1

    id = (current_shape.id + chamber.direction_index)

    chamber.drop_shape(current_shape)
    heights << chamber.height

    target = 2022
    if ids.include? id
      first_seen_index = ids.index id

      count_for_repeat = ids.count - first_seen_index
      amount_for_repeat = chamber.height - heights[first_seen_index]

      starting_amount = heights[first_seen_index]
      remaining_block_count = target - (first_seen_index + 1)
      remaining_repeat_count = remaining_block_count / count_for_repeat
      leftovers = remaining_block_count % count_for_repeat
      total = starting_amount + (remaining_repeat_count * amount_for_repeat) + 1

      stam = chamber.height
      leftovers.times do
        shape_index = shape_index % shape_strings.count
        current_shape = Shape.from_string(shape_strings[shape_index])
        shape_index += 1
        chamber.drop_shape(current_shape)
      end
      enam = chamber.height
      return total + (enam - stam)
    end
    ids << id

  end
  chamber.height + 1
end

input = File.read(__FILE__.gsub("main.rb", "input.txt"))
# puts "Part One: #{part_one(parse_input(input))}"
puts "Part Two: #{part_two(parse_input(input))}"
