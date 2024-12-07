require("set")
require_relative("../utils.rb")

input = "....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#..."
input = File.read("2024/day_six/input.txt")

grid = input.split("\n").map { _1.split("") }
start = nil
width = grid.first.count
height = grid.count

DIRS = [
  Vec2.new(0, -1),
  Vec2.new(1, 0),
  Vec2.new(0, 1),
  Vec2.new(-1, 0),
]

def valid_position(pos, width, height)
  pos.x >= 0 &&
    pos.y >= 0 &&
    pos.x < width &&
    pos.y < height
end

position = nil
height.times do |y|
  width.times do |x|
    if grid[y][x] == "^"
      position = Vec2.new(x, y)
      grid[y][x] = "."
    end
  end
end

current_dir = 0
path = Set.new
path << position.to_a

while true
  path << position.to_a
  next_pos = position.add(DIRS[current_dir])
  break unless valid_position(next_pos, width, height)

  if grid[next_pos.y][next_pos.x] == "#"
    puts "turning"
    current_dir += 1
    current_dir %= DIRS.count
    next_pos = position.add(DIRS[current_dir])
  end
  break unless valid_position(next_pos, width, height)

  position = next_pos
  puts position.to_a.inspect
end

puts path.count
