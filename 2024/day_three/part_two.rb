input = File.read("2024/day_three/input.txt")

instructions = input.scan(/(mul\(\d+,\d+\)|do\(\)|don't\(\))/)

score = 0
enabled = true
instructions.each do |instr|
  instr = instr[0]
  if instr == "do()"
    enabled = true
  elsif instr == "don't()"
    enabled = false
  else
    next unless enabled
    nums = instr.scan(/\d+/)
    score += nums[0].to_i * nums[1].to_i
  end
end

puts score
