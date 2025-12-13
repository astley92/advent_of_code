require_relative("../boot.rb")

solution = Solution.new(day: 10, year: 2025)

solution.add_input(File.read(File.join(__dir__, "input.txt")))
solution.add_input(<<~TXT, id: "test_input")
  [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
  [...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
  [.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
TXT

solution.add_test(part: 1, expected_answer: 7, input_id: "test_input")
solution.add_test(part: 2, expected_answer: 33, input_id: "test_input")

class Button
  def self.parse(str, len)
    nums = str[1...-1].split(",").map(&:to_i)
    vals = Array.new(len, 0)
    nums.each do |n|
      vals[n] = 1
    end
    new(vals.join.to_i(2), str, vals)
  end

  attr_reader :num
  def initialize(num, str, array)
    @num = num
    @str = str
    @array = array
  end

  def to_s
    "#{@str}: #{@num} - #{@num.to_s(2)}"
  end

  def to_a
    @array
  end
end

solution.add_solver(part: 1) do |input|
  total_presses = 0
  input.split("\n").each do |line|
    desired, *buttons, _joltage = line.split(" ")
    desired = desired[1...-1]
    desired = desired.gsub(".", "0")
    desired = desired.gsub("#", "1")
    desired_len = desired.length
    desired = desired.to_i(2)
    buttons = buttons.map { Button.parse(_1, desired_len) }

    press_count = 0
    states = [0]
    solved = false
    while !solved
      press_count += 1
      new_states = []
      states.each do |state|
        break if solved

        buttons.each do |button|
          break if solved

          res = state ^ button.num
          if res == desired
            solved = true
            break
          else
            new_states << res
          end
        end
      end
      states = new_states.uniq
    end

    total_presses += press_count
  end
  total_presses
end

solution.add_solver(part: 2) do |input|
  total_presses = 0
  input.split("\n").each do |line|
    _desired, *buttons, joltage = line.split(" ")
    joltage = joltage[1...-1].split(",").map(&:to_i)
    buttons = buttons.map { Button.parse(_1, joltage.length) }

    states = [Array.new(joltage.count, 0)]
    press_count = 0
    solved = false
    seen = Set.new
    while !solved
      puts states.count
      press_count += 1
      new_states = []
      states.each do |state|
        break if solved

        next if seen.include?(state)
        seen.add(state)
        buttons.each do |button|
          break if solved

          res = state.zip(button.to_a).map(&:sum)
          if res == joltage
            solved = true
          else
            valid = true
            res.each.with_index do |n, i|
              if n > joltage[i]
                valid = false
              end
            end
            new_states << res if valid
          end
        end
      end
      states = new_states.uniq
    end
    total_presses += press_count
  end
  total_presses
end

solution.run!
