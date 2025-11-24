require_relative("../utils.rb")

input = "p=0,4 v=3,-3
p=6,3 v=-1,-3
p=10,3 v=-1,2
p=2,0 v=2,-1
p=0,0 v=1,3
p=3,0 v=-2,-2
p=7,6 v=-1,-3
p=3,0 v=-1,-2
p=9,3 v=2,3
p=7,3 v=-1,2
p=2,4 v=2,-3
p=9,5 v=-3,-3"

input = File.read("2024/day_fourteen/input.txt")

WIDTH = 101
HEIGHT = 103
TIME = 100

robots = input.split("\n").map do |line|
  res = []
  p = Vec2.new(*line.split("=")[1].split(",").map(&:to_i))
  res << p
  v = Vec2.new(*line.split("=")[2].split(",").map(&:to_i))
  res << v
end

end_positions = []
robots.each do |rp, rv|
  end_pos = (rp + rv * TIME)
  end_pos.x = end_pos.x % WIDTH
  end_pos.y = end_pos.y % HEIGHT
  end_positions << end_pos
end

tl = []
tr = []
bl = []
br = []

mid_x = WIDTH / 2
mid_y = HEIGHT / 2

end_positions.each do |pos|
  next if pos.x == mid_x || pos.y == mid_y

  if pos.x < mid_x && pos.y < mid_y
    tl << pos
  elsif pos.x < mid_x && pos.y > mid_y
    bl << pos
  elsif pos.x > mid_x && pos.y < mid_y
    tr << pos
  else
    br << pos
  end
end
puts tl.count * tr.count * bl.count * br.count
