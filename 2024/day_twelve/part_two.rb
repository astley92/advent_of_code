require_relative("../utils.rb")

input = "AAAA
BBCD
BBCC
EEEC"

input = "EEEEE
EXXXX
EEEEE
EXXXX
EEEEE"

input = "RRRRIICCFF
RRRRIICCCF
VVRRRCCFFF
VVRCCCJFFF
VVVVCJJCFE
VVIVCCJJEE
VVIIICJJEE
MIIIIIJJEE
MIIISIJEEE
MMMISSJEEE"

input = "AAAAAA
AAABBA
AAABBA
ABBAAA
ABBAAA
AAAAAA"
input = File.read("2024/day_twelve/input.txt")

DIRS = [
  Vec2.new(0, -1),
  Vec2.new(1, 0),
  Vec2.new(0, 1),
  Vec2.new(-1, 0),
]

grid = Grid.from_string(input)
seen = Set.new()

class Node
  attr_reader :pos
  attr_accessor :edges

  def initialize(pos)
    @pos = pos
    @edges = []
  end
end

def find_plot_nodes(c, pos, grid, seen)
  p_seen = Set.new
  stack = [Node.new(pos)]
  plot_nodes = []
  while stack.any?
    current = stack.shift
    next if p_seen.include?(current.pos.to_a)

    p_seen << current.pos.to_a
    plot_nodes << current

    DIRS.each do |dir|
      next_pos = current.pos + dir
      next if grid.at(next_pos) != c || p_seen.include?(next_pos)

      next_node = Node.new(next_pos)
      current.edges << next_node
      stack << next_node
    end
  end
  plot_nodes
end

nodes = []
grid.each_with_pos do |c, pos|
  next if seen.include?(pos.to_a)

  p_nodes = find_plot_nodes(c, pos, grid, seen)
  nodes << p_nodes
  p_nodes.each { seen << _1.pos.to_a }
end

price = 0
nodes.each do |node_group|
  horizontal_sides = []
  vertical_sides = []
  node_group.each do |node|
    DIRS.each do |dir|
      neighbour = node.pos + dir
      next if node.edges.any? { _1.pos == neighbour }

      if dir.x == 1
        vertical_sides << [neighbour, dir]
      elsif dir.x == -1
        vertical_sides << [node.pos, dir]
      elsif dir.y == 1
        horizontal_sides << [neighbour, dir]
      else
        horizontal_sides << [node.pos, dir]
      end
    end
  end
  side_count = 0

  vertical_sides.map! { |pos, dir| pos.y + pos.x * 10000 * dir.x }
  side_count += vertical_sides.sort.slice_when { |a, b| (b - a).abs > 1 }.count
  horizontal_sides.map! { |pos, dir| pos.x + pos.y * 10000 * dir.y }
  side_count += horizontal_sides.sort.slice_when { |a, b| (b - a).abs > 1 }.count

  puts "#{node_group.count} * #{side_count} = #{side_count * node_group.count}"
  price += node_group.count * side_count
end

puts price
