require_relative("/Users/blakeastley/Projects/advent_of_code/ruby/runner.rb")
require("byebug")

runner = Runner.new
runner.add_test(:part_one, expected: 8, skip: false, input: <<~MSG)
..F7.
.FJ|.
SJ.L7
|F--J
LJ...
MSG

runner.add_test(:part_two, expected: 10, skip: false, input: <<~MSG)
FF7FSF7F7F7F7F7F---7
L|LJ||||||||||||F--J
FL-7LJLJ||||||LJL-77
F--JF--7||LJLJIF7FJ-
L---JF-JLJIIIIFJLJJ7
|F|F-JF---7IIIL7L|7|
|FFJF7L7F-JF7IIL---7
7-L-JL7||F7|L7F-7F7|
L.L7LFJ|||||FJL7||LJ
L7JLJL-JLJLJL--JLJ.L
MSG

module Solution
  module_function

  DIR_MAPPING = {
    north: [[0, -1], ["|", "7", "F"]],
    south: [[0, 1], ["|", "L", "J"]],
    east:  [[1, 0], ["-", "J", "7"]],
    west:  [[-1, 0], ["-", "L", "F"]],
  }

  PIPE_TO_AND_FROM_MAP = {
    "|" => [[0,1],[0,-1]],
    "-" => [[1,0],[-1,0]],
    "L" => [[0,-1],[1,0]],
    "J" => [[0,-1],[-1,0]],
    "7" => [[0,1],[-1,0]],
    "F" => [[0,1],[1,0]],
  }

  def part_one(raw_input)
    grid = parse(raw_input)
    pipe_path = walk_path(grid)
    pipe_path.count / 2
  end

  def part_two(raw_input)
    grid = parse(raw_input)
    width = grid.first.count
    height = grid.count
    pipe_path = walk_path(grid)
    trapped_count = 0
    grid.each_with_index do |row, y|
      row.each_with_index do |char, x|
        next unless pipe_path[[x, y]].nil?

        if is_trapped?([x, y], grid, pipe_path, width, height)
          trapped_count += 1
        end
      end
    end

    trapped_count
  end

  def is_trapped?(position, grid, pipe_path, width, height)
    right_score = build_coord_list(position, [1,0], width, height).map do |pos|
      pipe_path.fetch(pos, "")
    end.join.scan(/(\||L-*7|F-*J)/).count

    left_score = build_coord_list(position, [-1,0], width, height).map do |pos|
      pipe_path.fetch(pos, "")
    end.join.scan(/(\||7-*L|J-*F)/).count

    north_score = build_coord_list(position, [0,-1], width, height).map do |pos|
      pipe_path.fetch(pos, "")
    end.join.scan(/(-|J\|*F|L\|*7)/).count

    south_score = build_coord_list(position, [0,1], width, height).map do |pos|
      pipe_path.fetch(pos, "")
    end.join.scan(/(-|F\|*J|7\|*L)/).count

    [right_score, left_score, north_score, south_score].all?(&:odd?)
  end

  def build_coord_list(start_position, direction, width, height)
    positions = []
    current_position = start_position
    while current_position[0] >= 0 && current_position[0] < width && current_position[1] >= 0 && current_position[1] < height
      positions << current_position
      current_position = current_position.zip(direction).map(&:sum)
    end
    positions
  end

  def walk_path(grid)
    position = nil
    grid.each_with_index do |row, y|
      row.each_with_index do |char, x|
        if char == "S"
          position = [x, y]
          break
        end
      end
      break unless position.nil?
    end

    # Walk the path
    first_join_char = nil
    second_join_char = nil
    start_pos = position
    path = [[position, "S"]]
    path_map = {}
    path_map[position] = "S"
    while true
      if path.count > 1 && path[0] == path[-1]
        second_join_char = path[-2][1]
        break
      end

      current_char = grid[position[1]][position[0]]
      if current_char == "S"
        DIR_MAPPING.each do |_, (offset, possible_pipes)|
          next_pos = position.zip(offset).map(&:sum)
          next if next_pos[0] < 0 ||
            next_pos[1] < 0 ||
            next_pos[0] >= grid.first.count ||
            next_pos[1] >= grid.count

          next_char = grid[next_pos[1]][next_pos[0]]
          next unless possible_pipes.include?(next_char)

          first_join_char = next_char
          position = next_pos
        end
      else
        from_dir = path[-1][0].zip(path[-2][0]).map { _1[1] - _1[0] }
        next_position_offset = PIPE_TO_AND_FROM_MAP[current_char]
          .detect { _1 != from_dir }
        position = position.zip(next_position_offset).map(&:sum)
      end
      path << [position, grid[position[1]][position[0]]]
      path_map[position] = grid[position[1]][position[0]]
    end
    path_map[start_pos] = determine_join_char(first_join_char, second_join_char)
    path_map
  end

  def determine_join_char(*chars)
    case chars.sort.join
    when "J|"
      "F"
    when "7L"
      "-"
    when "F|"
      "L"
    else
      raise "Don't know how to join #{chars.inspect} #{chars.sort.join}"
    end
  end

  def parse(input)
    input.split("\n").map { _1.chars }
  end
end

# Part One Description
# --- Day 10: Pipe Maze ---
# You use the hang glider to ride the hot air from Desert Island all the way up
# to the floating metal island. This island is surprisingly cold and there
# definitely aren't any thermals to glide on, so you leave your hang glider
# behind.
#
# You wander around for a while, but you don't find any people or animals.
# However, you do occasionally find signposts labeled "Hot Springs" pointing in a
# seemingly consistent direction; maybe you can find someone at the hot springs
# and ask them where the desert-machine parts are made.
#
# The landscape here is alien; even the flowers and trees are made of metal. As
# you stop to admire some metal grass, you notice something metallic scurry away
# in your peripheral vision and jump into a big pipe! It didn't look like any
# animal you've ever seen; if you want a better look, you'll need to get ahead of
# it.
#
# Scanning the area, you discover that the entire field you're standing on is
# densely packed with pipes; it was hard to tell at first because they're the same
# metallic silver color as the "ground". You make a quick sketch of all of the
# surface pipes you can see (your puzzle input).
#
# The pipes are arranged in a two-dimensional grid of tiles:
#
#
# | is a vertical pipe connecting north and south.
# - is a horizontal pipe connecting east and west.
# L is a 90-degree bend connecting north and east.
# J is a 90-degree bend connecting north and west.
# 7 is a 90-degree bend connecting south and west.
# F is a 90-degree bend connecting south and east.
# . is ground; there is no pipe in this tile.
# S is the starting position of the animal; there is a pipe on this tile, but
# your sketch doesn't show what shape the pipe has.
#
# Based on the acoustics of the animal's scurrying, you're confident the pipe
# that contains the animal is one large, continuous loop.
#
# For example, here is a square loop of pipe:
#
# .....
# .F-7.
# .|.|.
# .L-J.
# .....
#
# If the animal had entered this loop in the northwest corner, the sketch would
# instead look like this:
#
# .....
# .S-7.
# .|.|.
# .L-J.
# .....
#
# In the above diagram, the S tile is still a 90-degree F bend: you can tell
# because of how the adjacent pipes connect to it.
#
# Unfortunately, there are also many pipes that aren't connected to the loop!
# This sketch shows the same loop as above:
#
# -L|F7
# 7S-7|
# L|7||
# -L-J|
# L|-JF
#
# In the above diagram, you can still figure out which pipes form the main loop:
# they're the ones connected to S, pipes those pipes connect to, pipes those pipes
# connect to, and so on. Every pipe in the main loop connects to its two neighbors
# (including S, which will have exactly two pipes connecting to it, and which is
# assumed to connect back to those two pipes).
#
# Here is a sketch that contains a slightly more complex main loop:
#
# ..F7.
# .FJ|.
# SJ.L7
# |F--J
# LJ...
#
# Here's the same example sketch with the extra, non-main-loop pipe tiles also
# shown:
#
# 7-F7-
# .FJ|7
# SJLL7
# |F--J
# LJ.LJ
#
# If you want to get out ahead of the animal, you should find the tile in the
# loop that is farthest from the starting position. Because the animal is in the
# pipe, it doesn't make sense to measure this by direct distance. Instead, you
# need to find the tile that would take the longest number of steps along the loop
# to reach from the starting point - regardless of which way around the loop the
# animal went.
#
# In the first example with the square loop:
#
# .....
# .S-7.
# .|.|.
# .L-J.
# .....
#
# You can count the distance each tile in the loop is from the starting point
# like this:
#
# .....
# .012.
# .1.3.
# .234.
# .....
#
# In this example, the farthest point from the start is 4 steps away.
#
# Here's the more complex loop again:
#
# ..F7.
# .FJ|.
# SJ.L7
# |F--J
# LJ...
#
# Here are the distances for each tile on that loop:
#
# ..45.
# .236.
# 01.78
# 14567
# 23...
#
# Find the single giant loop starting at S. How many steps along the loop does it
# take to get from the starting position to the point farthest from the starting
# position?

input = File.read(__FILE__.gsub("main.rb", "input.txt"))

runner.run!(input)
