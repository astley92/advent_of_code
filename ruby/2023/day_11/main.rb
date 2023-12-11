require_relative("/Users/blakeastley/Projects/advent_of_code/ruby/runner.rb")
require("byebug")

runner = Runner.new
runner.add_test(:part_one, expected: 374, skip: false, input: <<~MSG)
...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....
MSG

runner.add_test(:part_two, expected: 8410, skip: true, input: <<~MSG)
...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....
MSG

module Solution
  module_function

  def part_one(raw_input)
    expansion_multiplier = 1
    parsed_input = parse(raw_input)
    expanded_rows, expanded_cols = find_expansions(parsed_input)
    positions = []
    parsed_input.each_with_index do |row, y|
      row.each_with_index do |c, x|
        if c == "#"
          positions << [x, y]
        end
      end
    end

    distances = []
    i = 0
    while i < positions.count - 1
      k = i + 1
      while k < positions.count
        first = positions[i]
        second = positions[k]

        dist = (first[0] - second[0]).abs + (first[1] - second[1]).abs
        row_range = Range.new(*[first[1], second[1]].sort)
        col_range = Range.new(*[first[0], second[0]].sort)

        expanded_rows.each do |y|
          if row_range.cover?(y)
            dist += expansion_multiplier
          end
        end
        expanded_cols.each do |x|
          if col_range.cover?(x)
            dist += expansion_multiplier
          end
        end

        distances << dist
        k += 1
      end
      i += 1
    end

    distances.sum
  end

  def find_expansions(universe)
    expanded_rows = []
    universe.each_with_index do |row, index|
      if row.all? { _1 == "." }
        expanded_rows << index
      end
    end
    expanded_rows

    expanded_cols = []
    universe.transpose.each_with_index do |row, index|
      if row.all? { _1 == "." }
        expanded_cols << index
      end
    end

    [expanded_rows, expanded_cols]
  end

  def part_two(raw_input)
    expansion_multiplier = 999_999
    parsed_input = parse(raw_input)
    expanded_rows, expanded_cols = find_expansions(parsed_input)
    positions = []
    parsed_input.each_with_index do |row, y|
      row.each_with_index do |c, x|
        if c == "#"
          positions << [x, y]
        end
      end
    end

    distances = []
    i = 0
    while i < positions.count - 1
      k = i + 1
      while k < positions.count
        first = positions[i]
        second = positions[k]

        dist = (first[0] - second[0]).abs + (first[1] - second[1]).abs
        row_range = Range.new(*[first[1], second[1]].sort)
        col_range = Range.new(*[first[0], second[0]].sort)

        expanded_rows.each do |y|
          if row_range.cover?(y)
            dist += expansion_multiplier
          end
        end
        expanded_cols.each do |x|
          if col_range.cover?(x)
            dist += expansion_multiplier
          end
        end

        distances << dist
        k += 1
      end
      i += 1
    end

    distances.sum
  end

  def parse(input)
    input.split("\n").map(&:chars)
  end
end

# Part One Description
# --- Day 11: Cosmic Expansion ---
# You continue following signs for "Hot Springs" and eventually come across an
# observatory. The Elf within turns out to be a researcher studying cosmic
# expansion using the giant telescope here.
#
# He doesn't know anything about the missing machine parts; he's only visiting
# for this research project. However, he confirms that the hot springs are the
# next-closest area likely to have people; he'll even take you straight there once
# he's done with today's observation analysis.
#
# Maybe you can help him with the analysis to speed things up?
#
# The researcher has collected a bunch of data and compiled the data into a
# single giant image (your puzzle input). The image includes empty space (.) and
# galaxies (#). For example:
#
# ...#......
# .......#..
# #.........
# ..........
# ......#...
# .#........
# .........#
# ..........
# .......#..
# #...#.....
#
# The researcher is trying to figure out the sum of the lengths of the shortest
# path between every pair of galaxies. However, there's a catch: the universe
# expanded in the time it took the light from those galaxies to reach the
# observatory.
#
# Due to something involving gravitational effects, only some space expands. In
# fact, the result is that any rows or columns that contain no galaxies should all
# actually be twice as big.
#
# In the above example, three columns and two rows contain no galaxies:
#
#    v  v  v
#  ...#......
#  .......#..
#  #.........
# >..........<
#  ......#...
#  .#........
#  .........#
# >..........<
#  .......#..
#  #...#.....
#    ^  ^  ^
#
# These rows and columns need to be twice as big; the result of cosmic expansion
# therefore looks like this:
#
# ....#........
# .........#...
# #............
# .............
# .............
# ........#....
# .#...........
# ............#
# .............
# .............
# .........#...
# #....#.......
#
# Equipped with this expanded universe, the shortest path between every pair of
# galaxies can be found. It can help to assign every galaxy a unique number:
#
# ....1........
# .........2...
# 3............
# .............
# .............
# ........4....
# .5...........
# ............6
# .............
# .............
# .........7...
# 8....9.......
#
# In these 9 galaxies, there are 36 pairs. Only count each pair once; order
# within the pair doesn't matter. For each pair, find any shortest path between
# the two galaxies using only steps that move up, down, left, or right exactly one
# . or # at a time. (The shortest path between two galaxies is allowed to pass
# through another galaxy.)
#
# For example, here is one of the shortest paths between galaxies 5 and 9:
#
# ....1........
# .........2...
# 3............
# .............
# .............
# ........4....
# .5...........
# .##.........6
# ..##.........
# ...##........
# ....##...7...
# 8....9.......
#
# This path has length 9 because it takes a minimum of nine steps to get from
# galaxy 5 to galaxy 9 (the eight locations marked # plus the step onto galaxy 9
# itself). Here are some other example shortest path lengths:
#
#
# Between galaxy 1 and galaxy 7: 15
# Between galaxy 3 and galaxy 6: 17
# Between galaxy 8 and galaxy 9: 5
#
# In this example, after expanding the universe, the sum of the shortest path
# between all 36 pairs of galaxies is 374.
#
# Expand the universe, then find the length of the shortest path between every
# pair of galaxies. What is the sum of these lengths?

input = File.read(__FILE__.gsub("main.rb", "input.txt"))

runner.run!(input)
