require_relative("../utils.rb")

input = "2333133121414131402"
input = File.read("2024/day_nine/input.txt")

final_size = 0
expanded = []
i = 0
input.split("").each_slice(2) do |size, space|
  size.to_i.times do
    final_size += 1
    expanded << i
  end
  space.to_i.times do
    expanded << nil
  end
  i += 1
end
puts expanded.inspect

result = []
i = 0
nums_reversed = expanded[0..].reverse.compact
total_nums = nums_reversed.count
while i < total_nums
  current = expanded.shift
  if current == nil
    result << nums_reversed.shift
  else
    result << current
  end

  i += 1
end

checksum = 0
result.each_with_index do |num, i|
  checksum += num * i
end
puts checksum
