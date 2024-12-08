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

def extrapolate_positions(pos, dir, grid)
  current = pos
  result = []
  while current
    if grid.within_bounds?(current)
      result << current
      current += dir
    else
      current = nil
    end
  end
  result
end

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
  result += positions.map { [_1.x, _1.y] }
  while stack.any?
    current = stack.shift
    stack.each do |other|
      dist = other - current
      a1 = current + dist
      a2 = other + dist.reflection
      if grid.within_bounds?(a1)
        positions = extrapolate_positions(a1, dist, grid)
        result += positions.map { [_1.x, _1.y] }
        positions.each do |pos|
          grid.replace(pos, "#")
        end
      end
      if grid.within_bounds?(a2)
        positions = extrapolate_positions(a2, dist.reflection, grid)
        result += positions.map { [_1.x, _1.y] }
        positions.each do |pos|
          grid.replace(pos, "#")
        end
      end
    end
  end
end

puts grid.pretty_s
puts result.count
