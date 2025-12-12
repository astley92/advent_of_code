require_relative("../boot.rb")

solution = Solution.new(day: 6, year: 2025)

solution.add_input(File.read(File.join(__dir__, "input.txt")))
solution.add_input(<<~TXT, id: "test_input")
123 328  51 64
 45 64  387 23
  6 98  215 314
*   +   *   +
TXT

solution.add_test(part: 1, expected_answer: 4277556, input_id: "test_input")
solution.add_test(part: 2, expected_answer: 3263827, input_id: "test_input")

solution.add_solver(part: 1) do |input|
  lines = input.split("\n").map { _1.strip.split(/\s+/) }
  operations = lines[-1]
  total = 0
  operations.each.with_index do |op, x|
    nums = []
    lines[...-1].each do |line|
      nums << line[x].to_i
    end
    case op
    when "*"
      total += nums.reduce(1) { |acc, n| acc * n }
    when "+"
      total += nums.sum
    end
  end
  total
end

solution.add_solver(part: 2) do |input|
  lines = input.split("\n")
  operations = lines[-1].split(/\s+/).reverse
  max_line_len = lines.max_by { _1.length }.length
  num_lines = []
  lines[...-1].each do |line|
    while line.length < max_line_len
      line += " "
    end
    num_lines << line.reverse
  end

  total = 0
  ni = 0
  oi = 0
  nums = []
  while ni <= max_line_len
    digits = num_lines.map { _1[ni] }.reject { _1 == " " }
    if digits.empty? || digits.all?(&:nil?)
      op = operations[oi]
      case op
      when "*"
        total += nums.reduce(1) { |acc, n| acc * n }
      when "+"
        total += nums.sum
      end
      nums = []
      oi += 1
    else
      nums << digits.join.to_i
    end
    ni += 1
  end
  total
end

solution.run!
