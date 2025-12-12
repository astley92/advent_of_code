require_relative("../boot.rb")

solution = Solution.new(day: 7, year: 2025)

solution.add_input(File.read(File.join(__dir__, "input.txt")))
solution.add_input(<<~TXT, id: "test_input")
.......S.......
...............
.......^.......
...............
......^.^......
...............
.....^.^.^.....
...............
....^.^...^....
...............
...^.^...^.^...
...............
..^...^.....^..
...............
.^.^.^.^.^...^.
...............
TXT

solution.add_test(part: 1, expected_answer: 21, input_id: "test_input")
solution.add_test(part: 2, expected_answer: 40, input_id: "test_input")

START_CHAR = "S"
EMPTY_SPACE_CHAR = "."
SPLITTER_CHAR = "^"

class Node
  attr_reader :pos, :prev
  def initialize(pos:, prev:)
    @pos = pos
    @prev = [prev]
  end

  def x
    @pos.x
  end

  def y
    @pos.y
  end
end

def count_paths_home(node)
  @memo ||= {}
  return 1 if node.prev.any? { _1.nil? }

  cached = @memo[[node.pos.x, node.pos.y]]
  return cached if cached

  @memo[[node.pos.x, node.pos.y]] = node.prev.map { count_paths_home(_1) }.sum
end

solution.add_solver(part: 1) do |input|
  grid = Grid.parse(input)
  current = Vec2.new(*grid.coords_of("S").first)

  beams = [current]
  split_count = 0
  while beams.first.y < grid.height - 1
    new_beams = []

    beams.each do |beam|
      position_below = beam + Vec2::DOWN
      next_cell = grid.value_at(position_below)
      case next_cell
      when EMPTY_SPACE_CHAR
        new_beams << position_below
        grid.set_value_at(position_below, "|")
      when SPLITTER_CHAR
        split_count += 1
        [Vec2::LEFT, Vec2::RIGHT].each do |dir|
          new_pos = position_below + dir
          new_beams << new_pos if (0...grid.width).cover?(new_pos.x)
        end
      end
    end

    beams = new_beams.uniq { [_1.x, _1.y] }
  end
  split_count
end

solution.add_solver(part: 2) do |input|
  grid = Grid.parse(input)
  current = Vec2.new(*grid.coords_of("S").first)
  nodes = [Node.new(pos: current, prev: nil)]
  while nodes.first.y < grid.height - 1
    new_nodes = []
    nodes.each do |node|
      position_below = node.pos + Vec2::DOWN
      next_cell = grid.value_at(position_below)

      case next_cell
      when EMPTY_SPACE_CHAR
        existing_node = new_nodes.detect { _1.pos == position_below }
        if existing_node
          existing_node.prev << node
        else
          new_nodes << Node.new(pos: position_below, prev: node)
        end
      when SPLITTER_CHAR
        [Vec2::LEFT, Vec2::RIGHT].each do |dir|
          new_pos = position_below + dir
          next if new_pos.x < 0 || new_pos.x >= grid.width

          existing_node = new_nodes.detect { _1.pos == new_pos }
          if existing_node
            existing_node.prev << node
          else
            new_nodes << Node.new(pos: new_pos, prev: node)
          end
        end
      end
    end

    nodes = new_nodes
  end

  nodes.map(&method(:count_paths_home)).sum
end

solution.run!
