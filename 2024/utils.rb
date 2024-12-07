require("set")
require("byebug")

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

  def to_a
    [x, y]
  end
end

