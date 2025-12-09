class Line
  attr_reader :p1, :p2
  def initialize(p1, p2)
    @p1 = p1
    @p2 = p2
  end

  def intersects?(other)
    p1 = @p1
    p2 = @p2
    p3 = other.p1
    p4 = other.p2
    # A B are the line points
    # P is the point
    # (B.x - A.x) * (P.y - A.y) - (B.y - A.y) * (P.x - A.x)

    return false if p1 == p3 || p1 == p4 || p2 == p3 || p2 == p4

    # p1: A p3, B p4
    p1r = (p4.x - p3.x) * (p1.y - p3.y) - (p4.y - p3.y) * (p1.x - p3.x)

    # p2: A p3, B p4
    p2r = (p4.x - p3.x) * (p2.y - p3.y) - (p4.y - p3.y) * (p2.x - p3.x)

    # p3: A p1, B p2
    p3r = (p2.x - p1.x) * (p3.y - p1.y) - (p2.y - p1.y) * (p3.x - p1.x)

    # p4: A p1, B p2
    p4r = (p2.x - p1.x) * (p4.y - p1.y) - (p2.y - p1.y) * (p4.x - p1.x)

    return false if p1r == 0 || p2r == 0 || p3r == 0 || p4r == 0

    p1r.positive? != p2r.positive? && p3r.positive? != p4r.positive?
  end

  def contains_point?(point)
    if vertical?
      point.x == @p1.x && point.y >= [@p1.y, @p2.y].min && point.y <= [@p1.y, @p2.y].max
    else
      point.y == @p1.y && point.x >= [@p1.x, @p2.x].min && point.x <= [@p1.x, @p2.x].max
    end
  end

  def to_s
    "#{p1} - #{p2}"
  end

  def vertical?
    @p1.x == @p2.x && @p1.y != @p2.y
  end
end
