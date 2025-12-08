class Vec3
  attr_reader :x, :y, :z
  def initialize(x, y, z)
    @x = x
    @y = y
    @z = z
  end

  def distance_to(other)
    ((x - other.x) ** 2 + (y - other.y) ** 2 + (z - other.z) ** 2) ** 0.5
  end

  def to_s
    "#{self.class.name}(#{x}, #{y}, #{z})"
  end

  def ==(other)
    other.x == x && other.y == y && other.z == z
  end
end
