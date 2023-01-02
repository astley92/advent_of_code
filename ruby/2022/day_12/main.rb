##### Part One Description #####
# --- Day 12: Hill Climbing Algorithm ---
# You try contacting the Elves using your handheld device, but the river you're
# following must be too low to get a decent signal.
#
# You ask the device for a heightmap of the surrounding area (your puzzle input).
# The heightmap shows the local area from above broken into a grid; the elevation
# of each square of the grid is given by a single lowercase letter, where a is the
# lowest elevation, b is the next-lowest, and so on up to the highest elevation,
# z.
#
# Also included on the heightmap are marks for your current position (S) and the
# location that should get the best signal (E). Your current position (S) has
# elevation a, and the location that should get the best signal (E) has elevation
# z.
#
# You'd like to reach E, but to save energy, you should do it in as few steps as
# possible. During each step, you can move exactly one square up, down, left, or
# right. To avoid needing to get out your climbing gear, the elevation of the
# destination square can be at most one higher than the elevation of your current
# square; that is, if your current elevation is m, you could step to elevation n,
# but not to elevation o. (This also means that the elevation of the destination
# square can be much lower than the elevation of your current square.)
#
# For example:
#
# Sabqponm
# abcryxxl
# accszExk
# acctuvwj
# abdefghi
#
# Here, you start in the top-left corner; your goal is near the middle. You could
# start by moving down or right, but eventually you'll need to head toward the e
# at the bottom. From there, you can spiral around to the goal:
#
# v..v<<<<
# >v.vv<<^
# .>vv>E^^
# ..v>>>^^
# ..>>>>>^
#
# In the above diagram, the symbols indicate whether the path exits each square
# moving up (^), down (v), left (<), or right (>). The location that should get
# the best signal is still E, and . marks unvisited squares.
#
# This path reaches the goal in 31 steps, the fewest possible.
#
# What is the fewest steps required to move from your current position to the
# location that should get the best signal?

ALPHABET = ["S"] + ("a".."z").to_a + ["E"]
MAX_EL_GAIN = 1

class Node
  attr_reader :x, :y, :h_score, :g_score
  attr_accessor :parent
  def initialize(x:, y:, h_score:, g_score:, parent: nil)
    @x = x
    @y = y
    @h_score = h_score
    @g_score = g_score
    @parent = parent
  end

  def f_score
    @h_score + @g_score
  end

  def pos
    @pos ||= [x, y]
  end
end

class Grid
  NEIGHBOUR_DIRS = [
    [1, 0],
    [0, 1],
    [-1, 0],
    [0, -1],
  ]

  def initialize(cells)
    @cells = cells
  end

  def neighbours_for(node)
    NEIGHBOUR_DIRS.map do |dir_vec|
      x = node.x + dir_vec[0]
      y = node.y + dir_vec[1]
      Node.new(
        x: x,
        y: y,
        h_score: dist_between([x, y], [destination.x, destination.y]),
        g_score: node.g_score + 1,
        parent: node,
      )
    end.select { is_valid?(_1) }
  end

  def is_valid?(node)
    node.x >= 0 &&
      node.y >= 0 &&
      node.x < @cells.first.count &&
      node.y < @cells.count &&
      height_for(node) <= (height_for(node.parent)+1)
  end

  def height_for(node)
    @cells[node.y][node.x]
  end

  def start
    @start ||= find_start_node
  end

  def destination
    @destination ||= find_destination_node
  end

  def starting_possibilities
    possibles = []
    @cells.each_with_index do |line, row|
      line.each_with_index do |height, col|
        if [0, 1].include? height
          possibles << Node.new(
            x: col,
            y: row,
            h_score: dist_between([col, row], [destination.x, destination.y]),
            g_score: 0,
          )
        end
      end
    end
    possibles
  end

  def find_start_node
    @cells.each_with_index do |line, row|
      line.each_with_index do |height, col|
        if height == 0
          return Node.new(
            x: col,
            y: row,
            h_score: dist_between([col, row], [destination.x, destination.y]),
            g_score: 0,
          )
        end
      end
    end
  end

  def find_destination_node
    @cells.each_with_index do |line, row|
      line.each_with_index do |height, col|
        if height == 27
          return Node.new(x: col, y: row, h_score: nil, g_score: nil)
        end
      end
    end
  end

  def dist_between(a, b)
    (a[1] - b[1]).abs + (a[0] - b[0]).abs
  end
end

def parse_input(input)
  input.split("\n").map { _1.split("").map { |c| ALPHABET.index(c) } }
end

def part_one(input)
  grid = Grid.new(input)
  find_quickest_route(grid.start, grid.destination, grid)
end

def part_two(input)
  grid = Grid.new(input)
  possibles = grid.starting_possibilities
  index = 0
  prevs = []
  prev_best = Float::INFINITY
  possibles.each do |start|
    index += 1
    grid = Grid.new(input)
    res = find_quickest_route(start, grid.destination, grid)
    if res < prev_best
      prev_best = res
    end
  end
  prev_best
end

def find_quickest_route(start, destination, grid)
  queue = [start]
  closed = []
  while !queue.empty?
    current = queue.min_by { _1.f_score }
    queue = queue.reject { _1.pos == current.pos }

    grid.neighbours_for(current).each do |neighbour|
      if neighbour.pos == destination.pos
        destination.parent = neighbour
        break
      end

      next if queue.detect { (_1.pos == neighbour.pos) && _1.f_score < neighbour.f_score }

      if closed.detect { (_1.pos == neighbour.pos) && _1.f_score < neighbour.f_score }
        next
      else
        queue << neighbour
      end
    end

    closed << current
  end
  if destination.parent
    count_steps_from(destination.parent, to: start)
  else
    100000000000
  end
end

def count_steps_from(node, to:)
  count = 0
  current = node
  while true
    break if current.pos == to.pos

    count += 1
    current = current.parent
  end
  count
end

input = File.read(__FILE__.gsub("main.rb", "input.txt"))
puts "Part One: #{part_one(parse_input(input))}"
puts "Part Two: #{part_two(parse_input(input))}"
