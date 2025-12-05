require_relative("../boot.rb")

solution = Solution.new(day: 5, year: 2025)

solution.add_input(File.read(File.join(__dir__, "input.txt")))
solution.add_input(<<~TXT, id: "test_input")
3-5
10-14
16-20
12-18

1
5
8
11
17
32
TXT

solution.add_test(part: 1, expected_answer: 3, input_id: "test_input")
solution.add_test(part: 2, expected_answer: 14, input_id: "test_input")

class CustomRange
  attr_reader :min, :max
  def initialize(min, max)
    @min = min
    @max = max
  end

  def cover?(n)
    n >= @min && n <= @max
  end

  def overlap?(other)
    other.min <= @max && other.max >= @min
  end

  def count
    (@max - @min) + 1
  end
end

solution.add_solver(part: 1) do |input|
  range_lines, available_lines = input.split("\n\n")
  available_ings = available_lines.split("\n").map(&:to_i)
  ranges = range_lines.split("\n").map do |line|
    a, b = line.split("-").map(&:to_i)
    CustomRange.new(a, b)
  end
  available_ings.select do |ing|
    ranges.any? { _1.cover?(ing) }
  end.count
end

solution.add_solver(part: 2) do |input|
  range_lines, _ = input.split("\n\n")
  ranges = range_lines.split("\n").map do |line|
    a, b = line.split("-").map(&:to_i)
    CustomRange.new(a, b)
  end

  while true
    changed = false
    merged_ranges = []
    ranges.each do |range|
      overlapping_range = merged_ranges.detect { _1.overlap?(range) }
      if overlapping_range.nil?
        merged_ranges << range
      else
        changed = true
        merged_ranges.delete(overlapping_range)
        rmin = [range.min, overlapping_range.min].min
        rmax = [range.max, overlapping_range.max].max
        merged_ranges << CustomRange.new(rmin, rmax)
      end
    end
    break unless changed

    ranges = merged_ranges
  end

  merged_ranges.map(&:count).sum
end

solution.run!

