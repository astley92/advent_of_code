##### Part One Description #####
# --- Day 2: Password Philosophy ---
# Your flight departs in a few days from the coastal airport; the easiest way
# down to the coast from here is via toboggan.
#
# The shopkeeper at the North Pole Toboggan Rental Shop is having a bad day.
# "Something's wrong with our computers; we can't log in!" You ask if you can take
# a look.
#
# Their password database seems to be a little corrupted: some of the passwords
# wouldn't have been allowed by the Official Toboggan Corporate Policy that was in
# effect when they were chosen.
#
# To try to debug the problem, they have created a list (your puzzle input) of
# passwords (according to the corrupted database) and the corporate policy when
# that password was set.
#
# For example, suppose you have the following list:
#
# 1-3 a: abcde
# 1-3 b: cdefg
# 2-9 c: ccccccccc
#
# Each line gives the password policy and then the password. The password policy
# indicates the lowest and highest number of times a given letter must appear for
# the password to be valid. For example, 1-3 a means that the password must
# contain a at least 1 time and at most 3 times.
#
# In the above example, 2 passwords are valid. The middle password, cdefg, is
# not; it contains no instances of b, but needs at least 1. The first and third
# passwords are valid: they contain one a or nine c, both within the limits of
# their respective policies.
#
# How many passwords are valid according to their policies?

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
    input.split("\n").map { _1.gsub(":", "").split(" ") }
  end

  def part_one!
    res = 0
    input.each do |min_max_string, char, password|
      min, max = min_max_string.split("-").map(&:to_i)
      tally = password.chars.tally
      count = tally[char] || 0
      if max >= count && count >= min
        res += 1
      end
    end
    res
  end

  def part_two!
    res = 0
    input.each do |positions_string, char, password|
      pos_1, pos_2 = positions_string.split("-").map(&:to_i).map { _1 - 1 }
      possibles = [password.chars[pos_1], password.chars[pos_2]]
      next unless possibles.count { _1 == char } == 1

      res += 1
    end
    res
  end
end

input = File.read(__FILE__.gsub("main.rb", "input.txt"))
puts Solution.run!(input)
