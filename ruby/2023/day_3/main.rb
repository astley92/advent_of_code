require_relative("/Users/blakeastley/Projects/advent_of_code/ruby/runner.rb")
require("byebug")

runner = Runner.new
runner.add_test(:part_one, expected: 387, skip: false, input: <<~MSG)
...........................%......................................*.......+..........*...................................................387
666...%................&...............-...............*...................................%.....#.........................&............*...
MSG

runner.add_test(:part_two, expected: 467835, skip: false, input: <<~MSG)
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
MSG

module Solution
  module_function

  NON_SYMBOLS = ((0..9).map(&:to_s) + ["."]).to_a
  NEIGHBOURS = [
    [1,0],
    [1,1],
    [0,1],
    [-1,1],
    [-1,0],
    [-1,-1],
    [0,-1],
    [1,-1],
  ]

  def part_one(raw_input)
    parsed_input = parse(raw_input)
    numbers = []

    current_number = ""
    current_number_positions = []

    parsed_input.each_with_index do |line, y|
      line.chars.each_with_index do |char, x|
        if (0..9).map(&:to_s).include?(char)
          current_number += char
          current_number_positions << [x, y]
        else
          if current_number != ""
            if get_symbol_coords(current_number_positions, parsed_input).any?
              numbers << current_number.to_i
            end
            current_number = ""
            current_number_positions = []
          end
        end
      end

      if current_number != ""
        if get_symbol_coords(current_number_positions, parsed_input).any?
          numbers << current_number.to_i
        end
        current_number = ""
        current_number_positions = []
      end
    end

    numbers.sum
  end

  def get_symbol_coords(positions, lines)
    coords = []
    positions.each do |position|
      NEIGHBOURS.each do |neighbour|
        neighbour_pos = [position[0] + neighbour[0], position[1] + neighbour[1]]
        next if coords.include?(neighbour_pos) ||
          neighbour_pos[0] < 0 ||
          neighbour_pos[0] >= lines.first.length ||
          neighbour_pos[1] < 0 ||
          neighbour_pos[1] >= lines.count

        neighbour_char = lines[neighbour_pos[1]][neighbour_pos[0]]
        next if NON_SYMBOLS.include?(neighbour_char)

        coords << neighbour_pos
      end
    end
    coords
  end

  def part_two(raw_input)
    parsed_input = parse(raw_input)
    symbol_to_nums = {}

    current_number = ""
    current_number_positions = []
    parsed_input.each_with_index do |line, y|
      line.chars.each_with_index do |char, x|
        if (0..9).map(&:to_s).include?(char)
          current_number += char
          current_number_positions << [x, y]
        else
          if current_number != ""
            symbol_coords = get_symbol_coords(current_number_positions, parsed_input).uniq
            if symbol_coords.any?
              symbol_coords.each do |coord|
                if symbol_to_nums.key?(coord)
                  symbol_to_nums[coord] << current_number.to_i
                else
                  symbol_to_nums[coord] = [current_number.to_i]
                end
              end
            end
            current_number = ""
            current_number_positions = []
          end
        end
      end
    end

    symbol_to_nums.select do |key, value|
      value.count == 2
    end.values.map { _1.reduce(&:*) }.sum
  end

  def parse(input)
    input.split("\n")
  end
end

# Part One Description
# --- Day 3: Gear Ratios ---
# You and the Elf eventually reach a gondola lift station; he says the gondola
# lift will take you up to the water source, but this is as far as he can bring
# you. You go inside.
#
# It doesn't take long to find the gondolas, but there seems to be a problem:
# they're not moving.
#
# "Aaah!"
#
# You turn around to see a slightly-greasy Elf with a wrench and a look of
# surprise. "Sorry, I wasn't expecting anyone! The gondola lift isn't working
# right now; it'll still be a while before I can fix it." You offer to help.
#
# The engineer explains that an engine part seems to be missing from the engine,
# but nobody can figure out which one. If you can add up all the part numbers in
# the engine schematic, it should be easy to work out which part is missing.
#
# The engine schematic (your puzzle input) consists of a visual representation of
# the engine. There are lots of numbers and symbols you don't really understand,
# but apparently any number adjacent to a symbol, even diagonally, is a "part
# number" and should be included in your sum. (Periods (.) do not count as a
# symbol.)
#
# Here is an example engine schematic:
#
# 467..114..
# ...*......
# ..35..633.
# ......#...
# 617*......
# .....+.58.
# ..592.....
# ......755.
# ...$.*....
# .664.598..
#
# In this schematic, two numbers are not part numbers because they are not
# adjacent to a symbol: 114 (top right) and 58 (middle right). Every other number
# is adjacent to a symbol and so is a part number; their sum is 4361.
#
# Of course, the actual engine schematic is much larger. What is the sum of all
# of the part numbers in the engine schematic?

input = File.read(__FILE__.gsub("main.rb", "input.txt"))

runner.run!(input)
