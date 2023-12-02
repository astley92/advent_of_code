require("byebug")

test_one_input = <<~MSG
1969
100756
MSG

test_two_input = <<~MSG
1969
100756
MSG

expected_test_part_one_output = 654 + 33583
expected_test_part_two_output = 50346 + 966

module Solution
  module_function

  def part_one(raw_input)
    parsed_input = parse(raw_input)
    parsed_input.map { (_1/3)-2 }.sum
  end

  def part_two(raw_input)
    parsed_input = parse(raw_input)
    parsed_input.map { recurse_calc(_1) }.sum
  end

  def recurse_calc(amount, prev_amounts = [])
    required_amount = (amount / 3) - 2
    return prev_amounts.sum if required_amount <= 0

    prev_amounts.unshift(required_amount)
    recurse_calc(required_amount, prev_amounts)
  end

  def parse(input)
    input.split("\n").map(&:to_i)
  end
end

# Part One Description
# --- Day 1: The Tyranny of the Rocket Equation ---
# Santa has become stranded at the edge of the Solar System while delivering
# presents to other planets! To accurately calculate his position in space, safely
# align his warp drive, and return to Earth in time to save Christmas, he needs
# you to bring him measurements from fifty stars.
#
# Collect stars by solving puzzles. Two puzzles will be made available on each
# day in the Advent calendar; the second puzzle is unlocked when you complete the
# first. Each puzzle grants one star. Good luck!
#
# The Elves quickly load you into a spacecraft and prepare to launch.
#
# At the first Go / No Go poll, every Elf is Go until the Fuel Counter-Upper.
# They haven't determined the amount of fuel required yet.
#
# Fuel required to launch a given module is based on its mass. Specifically, to
# find the fuel required for a module, take its mass, divide by three, round down,
# and subtract 2.
#
# For example:
#
#
# For a mass of 12, divide by 3 and round down to get 4, then subtract 2 to get 2.
# For a mass of 14, dividing by 3 and rounding down still yields 4, so the fuel
# required is also 2.
# For a mass of 1969, the fuel required is 654.
# For a mass of 100756, the fuel required is 33583.
#
# The Fuel Counter-Upper needs to know the total fuel requirement. To find it,
# individually calculate the fuel needed for the mass of each module (your puzzle
# input), then add together all the fuel values.
#
# What is the sum of the fuel requirements for all of the modules on your
# spacecraft?

module Runner
  module_function

  def check(part, input, expected)
    return [true, nil] if expected == nil

    result = Solution.public_send(part, input)
    if result == expected
      return [true, nil]
    else
      return [false, result]
    end
  end

  def run(part, input)
    Solution.public_send(part, input)
  end
end

input = File.read(__FILE__.gsub("main.rb", "input.txt"))

p1_test = Runner.check(:part_one, test_one_input, expected_test_part_one_output)
if p1_test[0]
  puts "Test Passed!\nActual Answer: #{Runner.run(:part_one, input)}\n\n"
else
  puts "Part ONE test did not pass\nExpected: #{expected_test_part_one_output}\nGot: #{p1_test[1].inspect}\n"
  exit
end

input = File.read(__FILE__.gsub("main.rb", "input.txt"))

p2_test = Runner.check(:part_two, test_two_input, expected_test_part_two_output)
if p2_test[0]
  puts "Test Passed!\nActual Answer: #{Runner.run(:part_two, input)}\n"
else
  puts "Part TWO test did not pass\nExpected: #{expected_test_part_two_output}\nGot: #{p2_test[1].inspect}\n"
end
