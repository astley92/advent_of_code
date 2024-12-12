require_relative("../utils.rb")

input = "AAAA
BBCD
BBCC
EEEC"

# input = File.read("2024/day_twelve/input.txt")

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
  node_group.each do |node|
  end
end

puts price
