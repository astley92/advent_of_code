class Vec2
  attr_reader :x, :y
  def initialize(x, y)
    @x = x
    @y = y
  end

  def +(other)
    self.class.new(@x+other.x, @y+other.y)
  end

  def -(other)
    self.class.new(@x - other.x, @y - other.y)
  end

  def *(n)
    self.class.new(@x * n, @y * n)
  end

  def to_s
    "#{self.class.name}(#{x}, #{y})"
  end

  def ==(other)
    other.x == x && other.y == y
  end

  def unit
    newx =
      if @x > 0
        1
      elsif @x < 0
        -1
      else
        0
      end
    newy =
      if @y > 0
        1
      elsif @y < 0
        -1
      else
        0
      end
    self.class.new(newx, newy)
  end

  UP = Vec2.new(0, -1)
  DOWN = Vec2.new(0, 1)
  LEFT = Vec2.new(-1, 0)
  RIGHT = Vec2.new(1, 0)
end
