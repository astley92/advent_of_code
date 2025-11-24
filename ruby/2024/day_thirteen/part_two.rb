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

cost = 0
configuration_strs.each do |configuation_str|
  a_delta = Vec2.new(*configuation_str[0].scan(/\d+/)[..1].map(&:to_i))
  b_delta = Vec2.new(*configuation_str[1].scan(/\d+/)[..1].map(&:to_i))
  prize = Vec2.new(*configuation_str[2].scan(/\d+/)[..1].map(&:to_i))
  prize += Vec2.new(10000000000000, 10000000000000)
  # We want to know when a_press * a_delta + b_press * b_delta == prize
  # ax * aP + bx * bP = px
  # ay * aP + by * bP = py
  # ---------------------- * by bx and by respectively to make bP term the same
  # axbyaP + bybxbP = pxby
  # aybxaP + bybxbP = pybx
  # ---------------------- subtract the two equations
  # axbyaP - aybxaP = pxby - pybx
  # ---------------------- isolate aP
  # aP * (axby - aybx) = pxby - pybx
  # ---------------------- solve for aP
  # aP = pxby - pybx / axby - aybx
  # Bp = the remainder of length to go after a_presses of a

  a_presses = (prize.x*b_delta.y - prize.y*b_delta.x) / (a_delta.x*b_delta.y - a_delta.y*b_delta.x)
  b_presses = (prize.x - a_delta.x*a_presses) / b_delta.x

  if (a_presses * a_delta.x + b_presses * b_delta.x) == prize.x &&
    (a_presses * a_delta.y + b_presses * b_delta.y) == prize.y
    cost += a_presses * 3 + b_presses
  end
end

puts cost

