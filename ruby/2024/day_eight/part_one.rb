require_relative("../utils.rb")

input = "............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............"

input = File.read("2024/day_eight/input.txt")

grid = Grid.from_string(input)

antenna_pos_map = {}
grid.each_with_pos do |c, pos|
  if c.match?(/[\da-zA-Z]/)
    if antenna_pos_map.key?(c)
      antenna_pos_map[c] << pos
    else
      antenna_pos_map[c] = [pos]
    end
  end
end

result = Set.new
antenna_pos_map.each do |c, positions|
  stack = positions
  while stack.any?
    current = stack.shift
    stack.each do |other|
      dist = other - current
      a1 = current + dist
      a2 = other + dist.reflection
      if grid.within_bounds?(a1)
        result << [a1.x, a1.y]
        grid.replace(a1, "#")
      end
      if grid.within_bounds?(a2)
        result << [a2.x, a2.y]
        grid.replace(a2, "#")
      end
    end
  end
end

puts grid.pretty_s
puts result.count
