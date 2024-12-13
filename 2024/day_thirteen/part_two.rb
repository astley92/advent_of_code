require_relative("../utils.rb")

input = "Button A: X+94, Y+34
Button B: X+22, Y+67
Prize: X=8400, Y=5400

Button A: X+26, Y+66
Button B: X+67, Y+21
Prize: X=12748, Y=12176

Button A: X+17, Y+86
Button B: X+84, Y+37
Prize: X=7870, Y=6450

Button A: X+69, Y+23
Button B: X+27, Y+71
Prize: X=18641, Y=10279"
input = File.read("2024/day_thirteen/input.txt")

configuration_strs = input.split("\n\n").map { _1.split("\n") }
A_COST = 3
B_COST = 1

cost = 0

configuration_strs.each do |configuation_str|
  a_delta = Vec2.new(*configuation_str[0].scan(/\d+/)[..1].map(&:to_i))
  b_delta = Vec2.new(*configuation_str[1].scan(/\d+/)[..1].map(&:to_i))
  target = Vec2.new(*configuation_str[2].scan(/\d+/)[..1].map(&:to_i))

  hits = [0, 0]
  pos = Vec2.new(0, 0)
  stack = [[pos, 0, 0, 0]]
  possibles = []
  seen = Set.new
  while stack.any?
    current_pos, current_cost, a_hits, b_hits = stack.shift
    next if seen.include?([current_pos.to_a, current_cost, a_hits, b_hits])

    seen << [current_pos.to_a, current_cost, a_hits, b_hits]
    if current_pos == target
      possibles << current_cost
      next
    end

    next if current_pos.x > target.x
    next if current_pos.y > target.y

    if a_hits <= 100
      stack << [current_pos + a_delta, current_cost + A_COST, a_hits + 1, b_hits]
    end
    if b_hits <= 100
      stack << [current_pos + b_delta, current_cost + B_COST, a_hits, b_hits + 1]
    end
  end

  cost += possibles.min if possibles.count > 0
end

puts cost
