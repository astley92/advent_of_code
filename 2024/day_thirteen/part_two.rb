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
  prize_location = Vec2.new(*configuation_str[2].scan(/\d+/)[..1].map(&:to_i))
  prize_location += Vec2.new(10000000000000, 10000000000000)
  lowest = Float::INFINITY

  # We want to know when a_press * a_delta + b_press * b_delta == prize
  # Looking like a system of linear equations math problem
  # CBF on a Friday afternoon
  # TODO: Come back and do this
  (1..101).each do |a_press|
    (1..101).each do |b_press|
      if (a_delta * a_press + b_delta * b_press) == prize_location
        this_cost = a_press * 3 + b_press
        lowest = this_cost if this_cost < lowest
      end
    end
  end

  cost += lowest if lowest != Float::INFINITY
end

puts cost

