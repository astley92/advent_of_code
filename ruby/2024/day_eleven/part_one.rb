require_relative("../utils.rb")

# input = "125 17"
input = File.read("2024/day_eleven/input.txt")

STONE_LENGTH_T_MAP = {}
def length_after_time(stone, time)
  cached = STONE_LENGTH_T_MAP[[stone, time]]
  return cached unless cached.nil?

  if time == 0
    return 1
  else
    if stone == 0
      result = length_after_time(1, time-1)
      STONE_LENGTH_T_MAP[[stone, time]] = result
      return result
    elsif stone.to_s.length % 2 == 1
      result = length_after_time(stone * 2024, time-1)
      STONE_LENGTH_T_MAP[[stone, time]] = result
      return result
    else
      stone_s = stone.to_s
      stone_length = stone_s.length
      left = stone_s[0...stone_length / 2].to_i
      right = stone_s[stone_length / 2..].to_i
      result = length_after_time(left, time-1) + length_after_time(right, time-1)
      STONE_LENGTH_T_MAP[[stone, time]] = result
      return result
    end
  end
end

stones = input.split(" ").map(&:to_i)
puts stones.sum { length_after_time(_1, 25) }
