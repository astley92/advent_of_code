class Rectangle
  attr_reader :p1, :p2
  def initialize(p1, p2)
    @p1 = p1
    @p2 = p2
  end

  def area
    ((@p1.x - @p2.x).abs + 1) * ((@p1.y - @p2.y).abs + 1)
  end

  def corners
    [
      @p1,
      Vec2.new(@p1.x, @p2.y),
      @p2,
      Vec2.new(@p2.x, @p1.y),
    ]
  end

  def edges
    [
      Line.new(corners[0], corners[1]),
      Line.new(corners[1], corners[2]),
      Line.new(corners[2], corners[3]),
      Line.new(corners[3], corners[0]),
    ]
  end

  def points
    [@p1, @p2]
  end
end

