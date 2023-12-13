require_relative("/Users/blakeastley/Projects/advent_of_code/ruby/runner.rb")
require("byebug")

runner = Runner.new
runner.add_test(:part_one, expected: 800, skip: false, input: <<~MSG)
#......#....##.
####.###.#..##.
####.###.#...#.
#......#....##.
..##...#...#...
..#...#####.#..
#####.#####.###
...####...#..#.
...####...#..#.
MSG

runner.add_test(:part_two, expected: 400, skip: false, input: <<~MSG)
#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#
MSG

module Solution
  module_function

  def part_one(raw_input)
    patterns = parse(raw_input)
    results = []
    patterns.each do |pattern|
      results << find_fold_point(pattern)
    end
    results.sum
  end

  def part_two(raw_input)
    pattern_points = []
    patterns = parse(raw_input)
    patterns.each do |pattern|
      pattern_points << find_fold_point(pattern)
    end

    results = []
    patterns.each_with_index do |pattern, pattern_index|
      found = nil
      pattern.count.times do |y|
        pattern.first.count.times do |x|
          adjusted_pattern = flip([x, y], pattern)
          found = find_fold_point(adjusted_pattern, ignore: pattern_points[pattern_index])

          break unless found.nil?
        end
        break unless found.nil?
      end
      results << found
    end
    results.compact.sum
  end

  def flip(pos, pattern)
    new_pattern = []
    pattern.each_with_index do |row, y|
      if y != pos[1]
        new_pattern << row.clone
      else
        new_row = row.clone
        current_char = new_row[pos[0]]
        new_row[pos[0]] = current_char == "." ? "#" : "."
        new_pattern << new_row
      end
    end

    new_pattern
  end

  def find_fold_point(pattern, ignore: -1)
    fold_point = 1
    while fold_point < pattern.count
      top = pattern[...fold_point]
      bottom = pattern[fold_point..]
      score = fold_point * 100
      if score == ignore
        fold_point += 1
        next
      end

      if fold_point <= pattern.count/2
        bottom = bottom.first(top.count)
      else
        top = top.last(bottom.count)
      end

      if top == bottom.reverse
        return score
      end

      fold_point += 1
    end

    pattern = pattern.transpose
    fold_point = 1
    while fold_point < pattern.count
      top = pattern[...fold_point]
      bottom = pattern[fold_point..]
      score = fold_point
      if score == ignore
        fold_point += 1
        next
      end

      if fold_point <= pattern.count/2
        bottom = bottom.first(top.count)
      else
        top = top.last(bottom.count)
      end

      if top == bottom.reverse
        return score
      end

      fold_point += 1
    end
  end

  def parse(input)
    input.split("\n\n").map { _1.split("\n").map(&:chars) }
  end
end

# Part One Description
# --- Day 13: Point of Incidence ---
# With your help, the hot springs team locates an appropriate spring which
# launches you neatly and precisely up to the edge of Lava Island.
#
# There's just one problem: you don't see any lava.
#
# You do see a lot of ash and igneous rock; there are even what look like gray
# mountains scattered around. After a while, you make your way to a nearby cluster
# of mountains only to discover that the valley between them is completely full of
# large mirrors. Most of the mirrors seem to be aligned in a consistent way;
# perhaps you should head in that direction?
#
# As you move through the valley of mirrors, you find that several of them have
# fallen from the large metal frames keeping them in place. The mirrors are
# extremely flat and shiny, and many of the fallen mirrors have lodged into the
# ash at strange angles. Because the terrain is all one color, it's hard to tell
# where it's safe to walk or where you're about to run into a mirror.
#
# You note down the patterns of ash (.) and rocks (#) that you see as you walk
# (your puzzle input); perhaps by carefully analyzing these patterns, you can
# figure out where the mirrors are!
#
# For example:
#
# #.##..##.
# ..#.##.#.
# ##......#
# ##......#
# ..#.##.#.
# ..##..##.
# #.#.##.#.
#
# #...##..#
# #....#..#
# ..##..###
# #####.##.
# #####.##.
# ..##..###
# #....#..#
#
# To find the reflection in each pattern, you need to find a perfect reflection
# across either a horizontal line between two rows or across a vertical line
# between two columns.
#
# In the first pattern, the reflection is across a vertical line between two
# columns; arrows on each of the two columns point at the line between the
# columns:
#
# 123456789
#     ><
# #.##..##.
# ..#.##.#.
# ##......#
# ##......#
# ..#.##.#.
# ..##..##.
# #.#.##.#.
#     ><
# 123456789
#
# In this pattern, the line of reflection is the vertical line between columns 5
# and 6. Because the vertical line is not perfectly in the middle of the pattern,
# part of the pattern (column 1) has nowhere to reflect onto and can be ignored;
# every other column has a reflected column within the pattern and must match
# exactly: column 2 matches column 9, column 3 matches 8, 4 matches 7, and 5
# matches 6.
#
# The second pattern reflects across a horizontal line instead:
#
# 1 #...##..# 1
# 2 #....#..# 2
# 3 ..##..### 3
# 4v#####.##.v4
# 5^#####.##.^5
# 6 ..##..### 6
# 7 #....#..# 7
#
# This pattern reflects across the horizontal line between rows 4 and 5. Row 1
# would reflect with a hypothetical row 8, but since that's not in the pattern,
# row 1 doesn't need to match anything. The remaining rows match: row 2 matches
# row 7, row 3 matches row 6, and row 4 matches row 5.
#
# To summarize your pattern notes, add up the number of columns to the left of
# each vertical line of reflection; to that, also add 100 multiplied by the number
# of rows above each horizontal line of reflection. In the above example, the
# first pattern's vertical line has 5 columns to its left and the second pattern's
# horizontal line has 4 rows above it, a total of 405.
#
# Find the line of reflection in each of the patterns in your notes. What number
# do you get after summarizing all of your notes?

input = File.read(__FILE__.gsub("main.rb", "input.txt"))

runner.run!(input)
