require_relative("../boot.rb")

solution = Solution.new(day: 2, year: 2025)
solution.add_input(<<~TXT, id: "test_input")
  11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124
TXT

solution.add_test(part: 1, expected_answer: 1227775554, input_id: "test_input")
solution.add_test(part: 2, expected_answer: 4174379265, input_id: "test_input")

solution.add_input(File.read(File.join(__dir__, "input.txt")))

solution.add_solver(part: 1) do |input|
  ranges = input.split(",").map { Range.new(*_1.split("-").map(&:to_i)) }
  invalids = []
  ranges.each do |range|
    range.each do |n|
      n_s = n.to_s
      n_len = n_s.length
      if n_s[...n_len/2] == n_s[n_len/2..]
        invalids << n
      end
    end
  end

  invalids.sum
end

solution.add_solver(part: 2) do |input|
  ranges = input.split(",").map { Range.new(*_1.split("-").map(&:to_i)) }
  invalids = []

  ranges.each do |range|
    range.each do |n|
      n_c = n.to_s.chars
      i = 1

      while i <= n_c.length / 2
        val = n_c[...i]
        all_vals = n_c.each_slice(i).to_a

        if all_vals.all? { _1 == val }
          invalids << n
          break
        end
        i += 1
      end
    end
  end

  invalids.sum
end

solution.run!


