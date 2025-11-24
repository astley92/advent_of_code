require_relative("../utils.rb")

input = ".....0.
..4321.
..5..2.
..6543.
..7..4.
..8765.
..9...."

input = "..90..9
...1.98
...2..7
6543456
765.987
876....
987...."

input = "012345
123456
234567
345678
4.6789
56789."

input = File.read("2024/day_ten/input.txt")

DIRS = [
  Vec2.new(1, 0),
  Vec2.new(-1, 0),
  Vec2.new(0, 1),
  Vec2.new(0, -1),
]

def score_head(head, grid)
  stack = [head]
  score = 0
  while stack.any?
    current = stack.shift
    current_val = grid.at(current).to_i
    if current_val == 9
      score += 1
      next
    end

    DIRS.each do |dir|
      next_step = current + dir
      next_val = grid.at(next_step)&.to_i
      next if next_val.nil?

      h_delta = next_val - current_val
      stack << next_step if h_delta == 1
    end
  end
  return score
end

grid = Grid.from_string(input)
score = 0
grid.each_with_pos do |c, pos|
  score += score_head(pos, grid) if c == "0"
end

puts score
