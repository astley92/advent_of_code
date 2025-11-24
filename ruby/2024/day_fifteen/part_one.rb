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
grid = Grid.from_string(grid_str)
walls = []
current = nil
grid.each_with_pos do |c, pos|
  walls << pos if c == "#"
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

def find_nearest(c, grid, current, dir)
  while true
    current_val = grid.at(current)
    return current if current_val == "."
    return nil if current_val == "#"
    return nil if current_val == nil

    current += dir
  end
end

movements.each do |movement|
  neighbour = current + movement
  neighbour_val = grid.at(neighbour)
  next if neighbour_val == "#"

  if neighbour_val == "."
    grid.replace(neighbour, "@")
    grid.replace(current, ".")
    current = neighbour
    next
  end

  if neighbour_val == "O"
    nearest_space = find_nearest(".", grid, current, movement)
    next if nearest_space.nil?

    grid.replace(current, ".")
    grid.replace(current + movement, "@")
    dist = nearest_space - current
    steps = (dist.x + dist.y).abs
    while steps > 1
      dir_to_replace = movement * steps
      grid.replace(current + dir_to_replace, "O")
      steps -= 1
    end
    current += movement
  end
end

result = 0
grid.each_with_pos do |c, pos|
  next unless c == "O"

  result += pos.y * 100 + pos.x
end
puts result
