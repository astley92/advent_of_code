require_relative("../utils.rb")

input = "###############
#.......#....E#
#.#.###.#.###.#
#.....#.#...#.#
#.###.#####.#.#
#.#.#.......#.#
#.#.#####.###.#
#...........#.#
###.#.#####.#.#
#...#.....#.#.#
#.#.#.###.#.#.#
#.....#...#.#.#
#.###.#.#.#.#.#
#S..#.....#...#
###############"

input = File.read("2024/day_sixteen/input.txt")
grid = Grid.from_string(input)

start_pos = grid.positions_for("S").first
end_pos = grid.positions_for("E").first

open = [[start_pos, Vec2.new(1, 0), 0, 0, Float::INFINITY]]
found = []
pos_costs = Hash.new { |k, v| Float::INFINITY }

while open.any?
  current, current_dir, current_score, current_steps, current_f = open.min_by { _1[-1] }
  open.delete([current, current_dir, current_score, current_steps, current_f])

  puts "Current Distance Travelled: #{current_steps} : Found count: #{found.count}"

  pos_costs[current.to_a] = current_score + current_steps
  FOUR_DIRS.each do |dir|
    neighbour = current + dir
    next if dir == current_dir * -1
    next if grid.at(neighbour) == "#"

    dir_change_cost = current_dir == dir ? 0 : 1
    neighbour_g = current_score + dir_change_cost + current_steps + 1
    neighbour_h = (end_pos.x - start_pos.x).abs + (end_pos.y - start_pos.y).abs
    neighbour_f = neighbour_g + neighbour_h

    next if found.any? { _1 < current_score + dir_change_cost + current_steps + 1 }
    next if open.any? { _1[0] == neighbour && _1[-1] < neighbour_f }
    next if pos_costs[neighbour.to_a] < current_score + current_steps + 1

    open << [neighbour, dir, current_score + dir_change_cost * 1000, current_steps + 1, neighbour_f]
    if neighbour == end_pos
      found << current_score + dir_change_cost + current_steps + 1
    end
  end
end

puts found.min
