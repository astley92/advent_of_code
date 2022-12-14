##### Part One Description #####
# --- Day 9: Rope Bridge ---
# This rope bridge creaks as you walk along it. You aren't sure how old it is, or
# whether it can even support your weight.
#
# It seems to support the Elves just fine, though. The bridge spans a gorge which
# was carved out by the massive river far below you.
#
# You step carefully; as you do, the ropes stretch and twist. You decide to
# distract yourself by modeling rope physics; maybe you can even figure out where
# not to step.
#
# Consider a rope with a knot at each end; these knots mark the head and the tail
# of the rope. If the head moves far enough away from the tail, the tail is pulled
# toward the head.
#
# Due to nebulous reasoning involving Planck lengths, you should be able to model
# the positions of the knots on a two-dimensional grid. Then, by following a
# hypothetical series of motions (your puzzle input) for the head, you can
# determine how the tail will move.
#
# Due to the aforementioned Planck lengths, the rope must be quite short; in
# fact, the head (H) and tail (T) must always be touching (diagonally adjacent and
# even overlapping both count as touching):
#
# ....
# .TH.
# ....
#
# ....
# .H..
# ..T.
# ....
#
# ...
# .H. (H covers T)
# ...
#
# If the head is ever two steps directly up, down, left, or right from the tail,
# the tail must also move one step in that direction so it remains close enough:
#
# .....    .....    .....
# .TH.. -> .T.H. -> ..TH.
# .....    .....    .....
#
# ...    ...    ...
# .T.    .T.    ...
# .H. -> ... -> .T.
# ...    .H.    .H.
# ...    ...    ...
#
# Otherwise, if the head and tail aren't touching and aren't in the same row or
# column, the tail always moves one step diagonally to keep up:
#
# .....    .....    .....
# .....    ..H..    ..H..
# ..H.. -> ..... -> ..T..
# .T...    .T...    .....
# .....    .....    .....
#
# .....    .....    .....
# .....    .....    .....
# ..H.. -> ...H. -> ..TH.
# .T...    .T...    .....
# .....    .....    .....
#
# You just need to work out where the tail goes as the head follows a series of
# motions. Assume the head and the tail both start at the same position,
# overlapping.
#
# For example:
#
# R 4
# U 4
# L 3
# D 1
# R 4
# D 1
# L 5
# R 2
#
# This series of motions moves the head right four steps, then up four steps,
# then left three steps, then down one step, and so on. After each step, you'll
# need to update the position of the tail if the step means the head is no longer
# adjacent to the tail. Visually, these motions occur as follows (s marks the
# starting position as a reference point):
#
# == Initial State ==
#
# ......
# ......
# ......
# ......
# H.....  (H covers T, s)
#
# == R 4 ==
#
# ......
# ......
# ......
# ......
# TH....  (T covers s)
#
# ......
# ......
# ......
# ......
# sTH...
#
# ......
# ......
# ......
# ......
# s.TH..
#
# ......
# ......
# ......
# ......
# s..TH.
#
# == U 4 ==
#
# ......
# ......
# ......
# ....H.
# s..T..
#
# ......
# ......
# ....H.
# ....T.
# s.....
#
# ......
# ....H.
# ....T.
# ......
# s.....
#
# ....H.
# ....T.
# ......
# ......
# s.....
#
# == L 3 ==
#
# ...H..
# ....T.
# ......
# ......
# s.....
#
# ..HT..
# ......
# ......
# ......
# s.....
#
# .HT...
# ......
# ......
# ......
# s.....
#
# == D 1 ==
#
# ..T...
# .H....
# ......
# ......
# s.....
#
# == R 4 ==
#
# ..T...
# ..H...
# ......
# ......
# s.....
#
# ..T...
# ...H..
# ......
# ......
# s.....
#
# ......
# ...TH.
# ......
# ......
# s.....
#
# ......
# ....TH
# ......
# ......
# s.....
#
# == D 1 ==
#
# ......
# ....T.
# .....H
# ......
# s.....
#
# == L 5 ==
#
# ......
# ....T.
# ....H.
# ......
# s.....
#
# ......
# ....T.
# ...H..
# ......
# s.....
#
# ......
# ......
# ..HT..
# ......
# s.....
#
# ......
# ......
# .HT...
# ......
# s.....
#
# ......
# ......
# HT....
# ......
# s.....
#
# == R 2 ==
#
# ......
# ......
# .H....  (H covers T)
# ......
# s.....
#
# ......
# ......
# .TH...
# ......
# s.....
#
# After simulating the rope, you can count up all of the positions the tail
# visited at least once. In this diagram, s again marks the starting position
# (which the tail also visited) and # marks other positions the tail visited:
#
# ..##..
# ...##.
# .####.
# ....#.
# s###..
#
# So, there are 13 positions the tail visited at least once.
#
# Simulate your complete hypothetical series of motions. How many positions does
# the tail of the rope visit at least once?

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
    input.split("\n").map { _1.split(" ") }
  end

  DIRS = {
    "L" => [-1, 0],
    "U" => [0, -1],
    "R" => [1, 0],
    "D" => [0, 1],
    "LU" => [-1, -1],
    "LD" => [-1, 1],
    "RU" => [1, -1],
    "RD" => [1, 1],
  }

  require "byebug"
  def add_vec(a, b)
    [
      a[0] + b[0],
      a[1] + b[1],
    ]
  end

  def directly_diagonal?(a, b)
    (a[0] - b[0]).abs == 1 && (a[1] - b[1]).abs == 1
  end

  def distance(a, b)
    return 1.1 if directly_diagonal?(a, b)
    dist = [
      (a[0] - b[0]).abs,
      (a[1] - b[1]).abs,
    ]

    dist[0] + dist[1]
  end

  def find_vec(h, t)
    min = 100000000000000000
    min_vec = nil
    DIRS.each do |k, vec|
      dist = distance(h, add_vec(t, vec))
      if dist < min
        min = dist
        min_vec = vec
      end
    end
    return min_vec
  end

  def part_one!
    h = [0,0]
    t = [0,0]
    ts = [t]
    input.each do |dir, len|
      len = len.to_i
      len.times do
        h = add_vec(h, DIRS[dir])
        if distance(h, t) > 1.5
          t = add_vec(t, find_vec(h, t))
          ts << t
        end
      end
    end
    ts.uniq.count
  end

  def part_two!
    sections = [[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]]
    ts = [[0,0]]
    input.each do |dir, len|
      len = len.to_i
      len.times do
        head = sections[0]
        sections[0] = add_vec(head, DIRS[dir])
        sections.each_with_index do |current, index|
          next if index == 0
          next unless distance(current, sections[index-1]) > 1.5

          travel_vec = find_vec(sections[index-1], current)
          next_pos = add_vec(current, travel_vec)
          sections[index] = next_pos
        end
        ts << sections[-1]
      end
    end
    ts.uniq.count
  end
end

input = File.read(__FILE__.gsub("main.rb", "input.txt"))
puts Solution.run!(input)
