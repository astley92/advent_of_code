require_relative("../utils.rb")

input = "5,4
4,2
4,5
3,0
2,1
6,3
2,4
1,5
0,6
3,3
2,6
5,1
1,2
5,5
2,5
6,5
1,4
0,4
6,4
1,1
6,1
1,0
0,5
1,6
2,0"

input = File.read("2024/day_eighteen/input.txt")

DIM = 70

walls = input.split("\n").map { Vec2.new(*_1.split(",").map(&:to_i)) }
start_pos = Vec2.new(0,0)
end_pos = Vec2.new(DIM,DIM)
grid = Grid.from_string(("."*(DIM+1) + "\n")*(DIM+1))


def can_escape?(grid, start_pos, end_pos)
  open = [[start_pos, 0, Float::INFINITY]]
  pos_costs = Hash.new { |k, v| Float::INFINITY }

  while open.any?
    current, current_steps, current_f = open.min_by { _1[-1] }
    open.delete([current, current_steps, current_f])

    pos_costs[current.to_a] = current_steps
    FOUR_DIRS.each do |dir|
      neighbour = current + dir
      neighbour_val = grid.at(neighbour)
      next if neighbour_val == "#" || neighbour_val == nil

      neighbour_g = current_steps + 1
      neighbour_h = (end_pos.x - start_pos.x).abs + (end_pos.y - start_pos.y).abs
      neighbour_f = neighbour_g + neighbour_h

      next if open.any? { _1[0] == neighbour && _1[-1] < neighbour_f }
      next if pos_costs[neighbour.to_a] < current_steps + 1

      open << [neighbour, current_steps + 1, neighbour_f]
      if neighbour == end_pos
        return true
      end
    end
  end

  return false
end

WALL_START = 2876

walls[...WALL_START].each do |wall|
  grid.replace(wall, "#")
end

walls[WALL_START..].each do |wall|
  puts "checking"
  grid.replace(wall, "#")
  next if can_escape?(grid, start_pos, end_pos)

  puts wall.to_a.inspect
  break
end

