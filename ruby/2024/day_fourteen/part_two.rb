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

robots = input.split("\n").map do |line|
  res = []
  p = Vec2.new(*line.split("=")[1].split(",").map(&:to_i))
  res << p
  v = Vec2.new(*line.split("=")[2].split(",").map(&:to_i))
  res << v
end

i = 1
while true do
  puts i
  end_positions = []
  robots.each do |rp, rv|
    end_pos = (rp + rv * i)
    end_pos.x = end_pos.x % WIDTH
    end_pos.y = end_pos.y % HEIGHT
    end_positions << end_pos
  end

  mapping = end_positions.map { _1.y * 1000 + _1.x }
  break if mapping.sort.slice_when { |a, b| b - a != 1 }.map { _1.count }.max > 7

  i += 1
end

puts i

