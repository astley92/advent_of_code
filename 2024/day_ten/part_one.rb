require_relative("../utils.rb")

input = "...0...
...1...
...2...
6543456
7.....7
8.....8
9.....9"

input = "..90..9
...1.98
...2..7
6543456
765.987
876....
987...."

input = "10..9..
2...8..
3...7..
4567654
...8..3
...9..2
.....01"

input = File.read("2024/day_ten/input.txt")

DIRS = [
  Vec2.new(1, 0),
  Vec2.new(-1, 0),
  Vec2.new(0, 1),
  Vec2.new(0, -1),
]

def score_head(head, grid)
  seen = Set.new
  stack = [head]
  score = 0
  while stack.any?
    current = stack.shift
    next if seen.include?(current.to_a)

    seen << current.to_a
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
