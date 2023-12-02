require_relative("/Users/blakeastley/Projects/advent_of_code/ruby/runner.rb")
require("byebug")

runner = Runner.new
runner.add_test(:part_one, expected: nil, skip: false, input: <<~MSG)
MSG

runner.add_test(:part_two, expected: nil, skip: false, input: <<~MSG)
MSG

module Solution
  module_function

  def part_one(raw_input)
    parsed_input = parse(raw_input)
  end

  def part_two(raw_input)
    parsed_input = parse(raw_input)
  end

  def parse(input)
    input.split("\n")
  end
end

__aocli_problem_description__

__aocli_load_input__

runner.run!(input)
