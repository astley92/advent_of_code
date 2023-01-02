##### Part One Description #####
# --- Day 8: Treetop Tree House ---
# The expedition comes across a peculiar patch of tall trees all planted
# carefully in a grid. The Elves explain that a previous expedition planted these
# trees as a reforestation effort. Now, they're curious if this would be a good
# location for a tree house.
#
# First, determine whether there is enough tree cover here to keep a tree house
# hidden. To do this, you need to count the number of trees that are visible from
# outside the grid when looking directly along a row or column.
#
# The Elves have already launched a quadcopter to generate a map with the height
# of each tree (your puzzle input). For example:
#
# 30373
# 25512
# 65332
# 33549
# 35390
#
# Each tree is represented as a single digit whose value is its height, where 0
# is the shortest and 9 is the tallest.
#
# A tree is visible if all of the other trees between it and an edge of the grid
# are shorter than it. Only consider trees in the same row or column; that is,
# only look up, down, left, or right from any given tree.
#
# All of the trees around the edge of the grid are visible - since they are
# already on the edge, there are no trees to block the view. In this example, that
# only leaves the interior nine trees to consider:
#
#
# The top-left 5 is visible from the left and top. (It isn't visible from the
# right or bottom since other trees of height 5 are in the way.)
# The top-middle 5 is visible from the top and right.
# The top-right 1 is not visible from any direction; for it to be visible, there
# would need to only be trees of height 0 between it and an edge.
# The left-middle 5 is visible, but only from the right.
# The center 3 is not visible from any direction; for it to be visible, there
# would need to be only trees of at most height 2 between it and an edge.
# The right-middle 3 is visible from the right.
# In the bottom row, the middle 5 is visible, but the 3 and 4 are not.
#
# With 16 trees visible on the edge and another 5 visible in the interior, a
# total of 21 trees are visible in this arrangement.
#
# Consider your map; how many trees are visible from outside the grid?
require "byebug"
class Solution
  attr_accessor :input
  def initialize(input)
    @input = input
  end

  def self.run!(input)
    solution = new(parse_input(input))
    <<~MSG
      Part One: #{solution.part_one!}
      Part Two: #{solution.part_two!}
    MSG
  end

  def self.parse_input(input)
    # Parse input
    input.split("\n").map { _1.split("").map(&:to_i) }
  end

  def part_one!
    sum = 0
    input.each_with_index do |row, i|
      row.each_with_index do |col, x|
        if visible?(i, x)
          sum += 1
        end
      end
    end
    sum
  end

  def visible?(row, col)
    return true if row == input.first.length - 1
    return true if col == input.length - 1
    return true if row == 0
    return true if col == 0

    visible_from_top?(row, col) ||
      visible_from_bottom?(row, col) ||
      visible_from_left?(row, col) ||
      visible_from_right?(row, col)
  end

  def visible_from_top?(row, col)
    height = input[row][col]
    in_the_ways = input.transpose[col][...row]
    return in_the_ways.all? { _1 < height }
  end

  def visible_from_bottom?(row, col)
    height = input[row][col]
    in_the_ways = input.transpose[col][row+1..]
    return in_the_ways.all? { _1 < height }
  end

  def visible_from_left?(row, col)
    height = input[row][col]
    in_the_ways = input[row][...col]
    return in_the_ways.all? { _1 < height }
  end

  def visible_from_right?(row, col)
    height = input[row][col]
    in_the_ways = input[row][col+1..]
    return in_the_ways.all? { _1 < height }
  end

  def part_two!
    highest = 0
    input.each_with_index do |row, i|
      row.each_with_index do |col, x|
        score = scenic_score(i, x)
        if score > highest
          highest = score
        end
      end
    end
    highest
  end

  def scenic_score(row, col)
    left_score(row, col) * right_score(row, col) * bottom_score(row, col) * top_score(row, col)
  end

  def left_score(row, col)
    sum = 0
    value = input[row][col]
    current_x = col - 1
    while true
      break if current_x < 0
      other_val = input[row][current_x]
      sum += 1
      break if other_val >= value

      current_x -= 1
    end
    sum
  end

  def right_score(row, col)
    sum = 0
    value = input[row][col]
    current_x = col + 1
    while true
      break if current_x >= input.first.length
      other_val = input[row][current_x]
      sum += 1
      break if other_val >= value

      current_x += 1
    end
    sum
  end

  def top_score(row, col)
    sum = 0
    value = input[row][col]
    current_y = row + 1
    while true
      if current_y >= input.length
        break
      end
      other_val = input[current_y][col]
      sum += 1
      break if other_val >= value

      current_y += 1
    end
    sum
  end

  def bottom_score(row, col)
    sum = 0
    value = input[row][col]
    current_y = row - 1
    while true
      break if current_y < 0
      other_val = input[current_y][col]
      sum += 1
      break if other_val >= value

      current_y -= 1
    end
    sum
  end
end

input = File.read(__FILE__.gsub("main.rb", "input.txt"))
puts Solution.run!(input)
