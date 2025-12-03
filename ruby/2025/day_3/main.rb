require_relative("../boot.rb")

solution = Solution.new(day: 2, year: 2025)

solution.add_input(File.read(File.join(__dir__, "input.txt")))
solution.add_input(<<~TXT, id: "test_input")
987654321111111
811111111111119
234234234234278
818181911112111
TXT

solution.add_test(part: 1, expected_answer: 357, input_id: "test_input")
solution.add_test(part: 2, expected_answer: 3121910778619, input_id: "test_input")

def find_largest_in_order(nums, n, current = [])
  return current if n == 0

  largest = -1
  largest_i = -1
  nums.each.with_index do |num, i|
    if num > largest && n + i - 1 < nums.count
      largest = num
      largest_i = i
    end
  end

  current << largest
  find_largest_in_order(nums[largest_i+1..], n-1, current)
end

solution.add_solver(part: 1) do |input|
  banks = input.split("\n")
  banks.map do |b_s|
    nums = b_s.chars.map(&:to_i)
    find_largest_in_order(nums, 2).map(&:to_s).join.to_i
  end.sum
end

solution.add_solver(part: 2) do |input|
  banks = input.split("\n")
  banks.map do |b_s|
    nums = b_s.chars.map(&:to_i)
    find_largest_in_order(nums, 12).map(&:to_s).join.to_i
  end.sum
end

solution.run!

