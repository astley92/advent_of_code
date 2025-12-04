require_relative("../boot.rb")

solution = Solution.new(day: 2, year: 2025)

solution.add_input(File.read(File.join(__dir__, "input.txt")))
solution.add_input(<<~TXT, id: "test_input")
..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@.
TXT

solution.add_test(part: 1, expected_answer: 13, input_id: "test_input")
solution.add_test(part: 2, expected_answer: 43, input_id: "test_input")

PAPER_SYMBOL = "@"

def find_moveable_rolls(grid)
  roll_positions = []
  grid.each.with_index do |row, y|
    row.each.with_index do |cell, x|
      next unless cell == PAPER_SYMBOL

      current = Vec2.new(x, y)
      rolls = GridHelper::DIRS[8].select do |dir|
        neighbour = current + dir
        if neighbour.x < 0 || neighbour.x >= row.length || neighbour.y < 0 || neighbour.y >= grid.length
          false
        else
          grid[neighbour.y][neighbour.x] == PAPER_SYMBOL
        end
      end


      roll_positions += [current] if rolls.count < 4
    end
  end
  roll_positions 
end

solution.add_solver(part: 1) do |input|
  grid = input.split("\n").map(&:chars)
  find_moveable_rolls(grid).count
end

solution.add_solver(part: 2) do |input|
  grid = input.split("\n").map(&:chars)
  count = 0
  while true
    roll_positions = find_moveable_rolls(grid)
    break if roll_positions.count < 1

    count += roll_positions.count
    roll_positions.each do |pos|
      grid[pos.y][pos.x] = "x"
    end
  end
  count
end

solution.run!

