require_relative("../utils.rb")

input = "##########
#..O..O.O#
#......O.#
#.OO..O.O#
#..O@..O.#
#O#..O...#
#O..O..O.#
#.OO.O.OO#
#....O...#
##########

<vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
<<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
>^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
<><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^"

input = File.read("2024/day_fifteen/input.txt")

grid_str, movement_str = input.split("\n\n")
new_grid_str = ""
grid_str.split("\n").each_with_index do |line, y|
  line.split("").each_with_index do |c, x|
    case c
    when "#" then new_grid_str << "##"
    when "." then new_grid_str << ".."
    when "O" then new_grid_str << "[]"
    when "@" then new_grid_str << "@."
    end
  end
  new_grid_str << "\n"
end

grid = Grid.from_string(new_grid_str)

class Box
  attr_reader :left, :right
  def initialize(left:, right:)
    @left = left
    @right = right
  end
end

walls = []
boxes = []
current = nil

grid.each_with_pos do |c, pos|
  walls << pos if c == "#"
  boxes << Box.new(left: pos, right: pos + Vec2.new(1, 0)) if c == "["
  current = pos if c == "@"
end

movements = movement_str.split("").reject {_1 == "\n"}.map do |c|
  case c
  when ">" then Vec2.new(1, 0)
  when "<" then Vec2.new(-1, 0)
  when "v" then Vec2.new(0, 1)
  when "^" then Vec2.new(0, -1)
  else
    raise "nope #{c.inspect}"
  end
end

def detect_impacted_positions(grid, current, dir)
  dir.x != 0 ? detect_impacted_horizontal(grid, current, dir) : detect_impacted_vertical(grid, current, dir)
end

def detect_impacted_vertical(grid, current, dir)
  positions_to_move = []
  current_positions = [current]

  while true
    positions_to_move = [*current_positions, *positions_to_move]
    current_positions.map! { _1 + dir }
    return nil if current_positions.any? { grid.at(_1) == "#" }
    return positions_to_move if current_positions.all? { grid.at(_1) == "." }

    new_positions = []
    current_positions.each do |position|
      val = grid.at(position)
      next if val == "."

      if val == "["
        new_positions << position unless new_positions.any? { _1 == position }
        new_positions << position + Vec2.new(1, 0) unless new_positions.any? { _1 == position + Vec2.new(1, 0) }
      elsif val == "]"
        new_positions << position unless new_positions.any? { _1 == position }
        new_positions << position + Vec2.new(-1, 0) unless new_positions.any? { _1 == position + Vec2.new(-1, 0) }
      end
    end
    current_positions = new_positions.flatten
  end

  return positions
end

def detect_impacted_horizontal(grid, current, dir)
  positions = []

  while true
    current_val = grid.at(current)
    return nil if current_val == nil
    return nil if current_val == "#"
    return positions if current_val == "."

    positions.unshift(current)
    current += dir
  end
end

movements.each do |movement|
  neighbour = current + movement
  neighbour_val = grid.at(neighbour)
  puts "Moving from #{current.to_a} in dir #{movement.to_a}"
  puts grid.pretty_s
  next if neighbour_val == "#"

  if neighbour_val == "."
    grid.replace(neighbour, "@")
    grid.replace(current, ".")
    current = neighbour
    next
  end

  if %w[[ ]].include?(neighbour_val)
    impacted_positions = detect_impacted_positions(grid, current, movement)
    next if impacted_positions.nil?

    impacted_positions.each do |pos_to_shift|
      grid.replace(pos_to_shift + movement, grid.at(pos_to_shift))
      grid.replace(pos_to_shift, ".")
    end
    grid.replace(current, ".")
    current += movement
  end
end

puts "FINAL STATE"
puts grid.pretty_s

result = 0
count = 0
grid.each_with_pos do |c, pos|
  next unless c == "["

  count += 1
  dist = [
    pos.x,
    grid.width - (pos.x + 2)
  ].min

  puts "B##{count}: XDist=#{dist}:YDist#{pos.y} - X#{pos.x}:G#{grid.width}# = #{pos.y} * 100 + #{dist} = #{pos.y * 100 + dist}"
  result += pos.y * 100 + pos.x
end

puts result
