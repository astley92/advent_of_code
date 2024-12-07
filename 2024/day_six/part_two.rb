require("set")

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

class Vec2
  attr_reader :x, :y
  def initialize(x, y)
    @x = x
    @y = y
  end

  def add(other)
    self.class.new(other.x + x, other.y + y)
  end

  def to_a
    [x, y]
  end

  def to_s
    "x#{x}:y#{y}"
  end
end

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

def pos_results_in_loop?(o_position, s_position, grid, width, height)
  current_dir = 0
  path = Set.new
  new_grid = []
  grid.each do |line|
    new_grid << line[0..]
  end
  new_grid[o_position.y][o_position.x] = "#"
  position = s_position

  while true
    return true if path.include?(position.to_s + DIRS[current_dir].to_s)

    path << position.to_s + DIRS[current_dir].to_s
    next_pos = position.add(DIRS[current_dir])
    break unless valid_position(next_pos, width, height)

    while new_grid[next_pos.y][next_pos.x] == "#"
      current_dir += 1
      current_dir %= DIRS.count
      next_pos = position.add(DIRS[current_dir])
      break unless valid_position(next_pos, width, height)
    end

    position = next_pos
  end

  return false
end

total_times = width * height
i = 0
loop_paths = 0
width.times do |x|
  height.times do |y|
    i += 1
    next if [x, y] == position.to_a || grid[y][x] == "#"

    print("#{i} of #{total_times}\r")
    loops = pos_results_in_loop?(Vec2.new(x, y), position, grid, width, height)
    if loops
      loop_paths += 1
    end
  end
end

puts "\n\n"
puts loop_paths
