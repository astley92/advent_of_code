class Runner
  def initialize
    @tests = []
  end

  def add_test(part, expected:, input:, skip: false)
    @tests << Test.new(part: part, input: input, expected: expected, skipped: skip)
  end

  def run!(real_input)
    puts "#### Part One ####"
    if test_for?(:part_one)
      test!(:part_one)
    end
    run_real(:part_one, real_input.dup)
    puts "##################\n\n"
    puts "#### Part Two ####"
    if test_for?(:part_two)
      test!(:part_two)
    end
    run_real(:part_two, real_input.dup)
    puts "##################"
  end

  private

  def test_for?(part)
    @tests.any? { _1.part == part }
  end

  def test_for(part)
    @tests.detect { _1.part == part }
  end

  def test!(part)
    test_for(part).run!
  end

  def run_real(part, input)
    puts Solution.public_send(part, input)
  end

  class Test
    attr_reader :part
    def initialize(part:, input:, expected:, skipped:)
      @part = part
      @input = input
      @expected_output = expected
      @skipped = skipped
    end

    def run!
      if @skipped
        puts "Skipping test\n"
        return
      end

      result = Solution.public_send(@part, @input)
      if result == @expected_output
        puts "Test Pass!\n"
      else
        puts "Test Fail!\nExpected: #{@expected_output.inspect}\nGot: #{result.inspect}\n\n"
        exit
      end
    end
  end
end
