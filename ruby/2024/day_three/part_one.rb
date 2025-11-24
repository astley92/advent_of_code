input = File.read("2024/day_three/input.txt")
instructions = input.scan(/mul\(\d+,\d+\)/)

score = 0
instructions.each do |instr|
  nums = instr.scan(/\d+/)
  score += nums[0].to_i * nums[1].to_i
end

puts score
