require_relative("../boot.rb")

solution = Solution.new(day: 9, year: 2025)

solution.add_input(File.read(File.join(__dir__, "input.txt")))
solution.add_input(<<~TXT, id: "test_input")
7,1
11,1
11,7
9,7
9,5
2,5
2,3
7,3
TXT

solution.add_test(part: 1, expected_answer: 50, input_id: "test_input")
solution.add_test(part: 2, expected_answer: 24, input_id: "test_input")

solution.add_solver(part: 1) do |input|
  positions = input.split("\n").map { _1.split(",").map(&:to_i) }.map { Vec2.new(*_1) }
  areas = []
  positions.each.with_index do |p1, i|
    positions[i+1..].each do |p2|
      r = Rectangle.new(p1, p2)
      areas << r.area
    end
  end
  areas.sort.last
end

def lines_contain_rect?(lines, rect)
  lines.each do |l1|
    rect.edges.each do |l2|
      next if l1.vertical? == l2.vertical?

      if l1.intersects?(l2)
        return false
      end
    end
  end
  points_within_lines?(rect.corners, lines)
end

def points_within_lines?(points, lines)
  points.all? do |point|
    res = nil
    dirs = Grid::DIRS[8][..3]
    containing_line = lines.detect { _1.contains_point?(point) }
    if containing_line
      res = true
    else
      counts = dirs.map do |dir|
        ray = Line.new(point, point + (dir*100000000000000))
        lines.select { _1.intersects?(ray) }.count.odd?
      end.tally
      res = (counts[true] || 0) >= (counts[false] || 0)
    end
    res
  end
end

solution.add_solver(part: 2) do |input, is_test| positions = input.split("\n").map {
  _1.split(",").map(&:to_i) }.map { Vec2.new(*_1) }

  lines = []
  positions.each_with_index do |p1, i|
    p2i = (i + 1) % positions.count
    p2 = positions[p2i]
    lines << Line.new(p1, p2)
  end

  rectangles = []
  positions.each.with_index do |p1, i|
    positions[i+1..].each do |p2|
      rectangles << Rectangle.new(p1, p2)
    end
  end

  sorted = rectangles.sort_by { _1.area }.reverse
  rect_count = sorted.count

  SCALE = is_test ? 100 : 0.01
  width = lines.flat_map { [_1.p1, _1.p2] }.max_by(&:x).x
  height = lines.flat_map { [_1.p1, _1.p2] }.max_by(&:y).y
  imgl = Magick::ImageList.new
  imgl.new_image((width+2) * SCALE, (height+2) * SCALE)

  gc = Magick::Draw.new
  gc.stroke("blue")
  gc.stroke_width(is_test ? 4 : 2)
  lines.each do |line|
    gc.line(line.p1.x*SCALE, line.p1.y*SCALE, line.p2.x*SCALE, line.p2.y*SCALE)
  end
  gc.fill_opacity(0)
  gc.stroke_width(is_test ? 4 : 2)

  result = nil
  sorted.each.with_index do |rectangle, i|
    puts "Checking #{i} of #{rect_count}"
    if lines_contain_rect?(lines, rectangle)
      p1, p2 = rectangle.points
      gc.stroke("green")
      result = rectangle.area if result == nil
      gc.rectangle(p1.x * SCALE, p1.y * SCALE, p2.x * SCALE, p2.y * SCALE)
      gc.stroke("black")
      gc.stroke_width(2)
      gc.circle(p1.x*SCALE, p1.y*SCALE, (p1.x*SCALE)+10, p1.y*SCALE)
      gc.circle(p2.x*SCALE, p2.y*SCALE, (p2.x*SCALE)+10, p2.y*SCALE)
      gc.font_style(Magick::NormalStyle)
      gc.font_weight(Magick::NormalWeight)
      gc.stroke_width(1)
      gc.pointsize(14)
      gc.text(p1.x*SCALE - 20, p1.y*SCALE - 20, "(#{p1.x}, #{p1.y})")
      gc.text(p2.x*SCALE - 20, p2.y*SCALE - 20, "(#{p2.x}, #{p2.y})")
      break
    end
  end

  gc.draw(imgl)
  imgl.write("day9-#{is_test}.png")

  result
end

solution.run!
