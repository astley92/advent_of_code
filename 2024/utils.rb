require("set")
require("byebug")

class Grid
  def self.from_string(str)
    new(str.split("\n").map { _1.split("") })
  end

  def initialize(state)
    @state = state
    @width = @state.first.count
    @height = @state.count
  end

  def each_with_pos
    @state.each_with_index do |line, y|
      line.each_with_index do |c, x|
        yield(c, Vec2.new(x, y))
      end
    end
  end

  def within_bounds?(pos)
    pos.x >= 0 &&
      pos.x < @width &&
      pos.y >= 0 &&
      pos.y < @height
  end

  def at(pos)
    return nil unless within_bounds?(pos)

    @state[pos.y][pos.x]
  end

  def replace(pos, c)
    @state[pos.y][pos.x] = c
  end

  def pretty_s
    @state.map { _1.join }.join("\n")
  end
end

class OpGenerator
  def initialize(symbols:)
    @symbols = symbols
    @count_ops_map = { 1 => symbols.map { [_1] } }
  end

  def ops_for(count)
    return @count_ops_map[count] if @count_ops_map[count]

    prev = ops_for(count-1)
    current = []
    prev.each do |op|
      @symbols.each do |o|
        current << op + [o]
      end
    end
    @count_ops_map[count] = current
  end
end

class Vec2
  attr_reader :x, :y
  def initialize(x, y)
    @x = x
    @y = y
  end

  def add(other)
    self.class.new(other.x + x, other.y + y)
  end

  def +(other)
    self.class.new(other.x + x, other.y + y)
  end

  def -(other)
    self.class.new(other.x - x, other.y - y)
  end

  def ==(other)
    @x == other.x && @y == other.y
  end

  def reflection
    self.class.new(-x, -y)
  end

  def to_a
    [x, y]
  end
end

