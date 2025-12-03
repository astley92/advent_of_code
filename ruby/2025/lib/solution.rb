class Solution
  def initialize(day:, year:)
    @day = day
    @year = year
    @inputs = {}
    @tests = []
    @solvers = {}
    @parts = []
  end

  def add_input(input, id: "default")
    @inputs[id] = Solution::Input.new(input, id:)
  end

  def add_test(part:, expected_answer:, input_id:)
    @tests << Solution::Test.new(part:, expected_answer:, input_id:)
  end

  def add_solver(part:, &block)
    @parts << part unless @parts.include?(part)
    @solvers[part] = block
  end

  def run!(skip_tests: false)
    print "\033[2J\033[H"
    puts "### AOC #{@year} #{@day} ###"
    puts "### Running tests"

    @tests.each do |test|
      input = @inputs[test.input_id]
      raise ArgumentError, "Input with id #{test.input_id.inspect} can not be found" unless input

      result = @solvers[test.part].call(input.copy)
      test_pass = result == test.expected_answer

      if test_pass
        puts "\033[32mPass\033[0m"
      else
        puts "\033[31mFail: expected #{result} to eq #{test.expected_answer}\033[0m"
        exit(1)
      end
    end

    puts "### Running solution"
    @parts.sort.each do |part|
      puts "### Part #{part}"
      input = @inputs["default"]
      raise ArgumentError, "Input with id #{test.input_id.inspect} can not be found" unless input

      result = @solvers[part].call(input.copy)
      puts "Answer: #{result}"
    end
  end
end

class Solution::Input
  def initialize(data, id:)
    @data = data
    @id = id
  end

  def copy
    @data.clone
  end
end

class Solution::Test
  attr_reader :input_id, :part, :expected_answer

  def initialize(part:, expected_answer:, input_id:)
    @part = part
    @expected_answer = expected_answer
    @input_id = input_id
  end
end

