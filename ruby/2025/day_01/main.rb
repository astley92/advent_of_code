require_relative("../boot.rb")

solution = Solution.new(day: 1, year: 2025)
solution.add_input(File.read(File.join(__dir__, "input.txt")))
solution.add_input(<<~TXT, id: "test_input")
  L68
  L30
  R48
  L5
  R60
  L55
  L1
  L99
  R14
  L82
TXT

solution.add_test(part: 1, expected_answer: 3, input_id: "test_input")
solution.add_test(part: 2, expected_answer: 6, input_id: "test_input")

solution.add_solver(part: 1) do |input|
  counter = 0
  i = 50
  input.split("\n").each do |line|
    direction = line[0]
    amount = line[1..].to_i

    if direction == "L"
      i -= amount
    else
      i += amount
    end

    i %= 100
    counter += 1 if i == 0
  end

  counter
end

solution.add_solver(part: 2) do |input|
  counter = 0
  i = 50
  input.split("\n").each do |line|
    delta = line[0] == "L" ? -1 : 1
    amount = line[1..].to_i

    amount.times do
      i += delta

      if i == 100
        i = 0
      elsif i == -1
        i = 99
      end

      counter += 1 if i == 0
    end
  end

  counter
end

solution.run!
