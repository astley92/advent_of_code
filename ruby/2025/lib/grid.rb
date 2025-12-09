class Grid
  DIRS = {
    8 => [
      Vec2.new(1, 1),
      Vec2.new(1, -1),
      Vec2.new(-1, -1),
      Vec2.new(-1, 1),
      Vec2.new(0, 1),
      Vec2.new(0, -1),
      Vec2.new(1, 0),
      Vec2.new(-1, 0),
    ],
    4 => [
      Vec2.new(0, 1),
      Vec2.new(0, -1),
      Vec2.new(1, 0),
      Vec2.new(-1, 0),
    ]
  }

  attr_reader :height, :width

  def self.parse(str, row_delim="\n", cell_delim="")
    new(str.split(row_delim).map { _1.split(cell_delim) } )
  end

  def self.empty(width, height, fill: 0)
    data = []
    height.times do |i|
      row = []
      width.times do
        row << fill
      end
      data << row
    end
    new(data)
  end

  def coords_of(c)
    res = []
    each_cell_with_indices do |cell, y, x|
      res << [x, y] if cell == c
    end
    res
  end

  def value_at(position)
    @data[position.y][position.x]
  end

  def set_value_at(position, value)
    @data[position.y][position.x] = value
  end

  def to_s
    @data.map { _1.join }.join("\n")
  end

  def each_cell_with_indices
    @data.each.with_index do |row, y|
      row.each.with_index do |cell, x|
        yield(cell, y, x)
      end
    end
  end

  private

  def initialize(data)
    @data = data
    @height = data.count
    @width = data.first.count
  end
end
